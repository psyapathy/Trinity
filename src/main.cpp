#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <QJsonArray>
#include <QAction>
#include <QMenu>
#include <QSystemTrayIcon>
#include <QMessageBox>
#include <QApplication>
#include <QtQuick/QQuickWindow>
#include <qtwebengineglobal.h>

#include "eventmodel.h"
#include "membermodel.h"
#include "matrixcore.h"
#include "network.h"
#include "desktop.h"
#include "communitylistmodel.h"
#include "community.h"
#include "roomlistsortmodel.h"
#include "emote.h"
#include "callobject.h"

QNetworkAccessManager* network::manager;
QString network::homeserverURL, network::accessToken;

int main(int argc, char* argv[]) {
    QApplication app2(argc, argv);

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setApplicationName("Trinity");

    qRegisterMetaType<RequestSender>();

    network::manager = new QNetworkAccessManager();

    network::homeserverURL = "https://matrix.org";

    // matrix
    qmlRegisterUncreatableType<EventModel>("trinity.matrix", 1, 0, "EventModel", "");
    qmlRegisterUncreatableType<MatrixCore>("trinity.matrix", 1, 0, "MatrixCore", "");
    qmlRegisterUncreatableType<Room>("trinity.matrix", 1, 0, "Room", "");
    qmlRegisterUncreatableType<Event>("trinity.matrix", 1, 0, "Event", "");
    qmlRegisterUncreatableType<Member>("trinity.matrix", 1, 0, "Member", "");
    qmlRegisterUncreatableType<Community>("trinity.matrix", 1, 0, "Community", "");
    qmlRegisterUncreatableType<Emote>("trinity.matrix", 1, 0, "Emote", "");
    qmlRegisterType<CommunityListModel>("trinity.matrix", 1, 0, "CommunityListModel");
    qmlRegisterType<CallObject>("trinity.matrix", 1, 0, "CallObject");

    // platform
    qmlRegisterUncreatableType<Desktop>("trinity.platform.desktop", 1, 0, "Desktop", "");

    QtWebEngine::initialize();

    QQmlApplicationEngine engine;
    QQmlContext* context = new QQmlContext(engine.rootContext(), &engine);

    MatrixCore matrix;
    Desktop desktop;

    QSystemTrayIcon* trayIcon = new QSystemTrayIcon(QIcon(":/icons/trinity-idle.png"));

    desktop.icon = trayIcon;

    context->setContextProperty("desktop", &desktop);
    context->setContextProperty("matrix", &matrix);

    QQmlComponent component(&engine);
    component.loadUrl(QUrl("qrc:/main.qml"));

    QObject* root = component.create(context);

    QObject::connect(trayIcon, &QSystemTrayIcon::activated, [root](QSystemTrayIcon::ActivationReason reason) {
        QQuickWindow* window = qobject_cast<QQuickWindow*>(root);

        if(reason == QSystemTrayIcon::ActivationReason::Trigger)
            window->setVisible(!window->isVisible());
    });

    QAction* openAction = new QAction("Open Trinity");
    QObject::connect(openAction, &QAction::triggered, [root] {
        QQuickWindow* window = qobject_cast<QQuickWindow*>(root);
        window->setVisible(true);
    });

    QAction* hideAction = new QAction("Quit");
    QObject::connect(hideAction, &QAction::triggered, [] {
        QCoreApplication::quit();
    });

    QMenu* trayMenu = new QMenu();
    trayMenu->addAction(openAction);
    trayMenu->addAction(hideAction);

    trayIcon->setContextMenu(trayMenu);

    return app2.exec();
}
