#pragma once

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonObject>
#include <QJsonDocument>
#include <QUrl>
#include <QNetworkReply>

namespace network {
  extern QNetworkAccessManager* manager;
  extern QString homeserverURL, accessToken;

  template<typename Fn>
  inline void postJSON(const QString& path, const QJsonObject object, Fn&& fn) {
    QNetworkRequest request(homeserverURL + path);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", accessToken.toLocal8Bit());

    const QByteArray jsonPost = QJsonDocument(object).toJson();

    request.setHeader(QNetworkRequest::ContentLengthHeader, QByteArray::number(jsonPost.size()));

    QNetworkReply* reply = manager->post(request, jsonPost);
    reply->connect(reply, &QNetworkReply::finished, [reply, fn] {
        fn(reply);
        reply->deleteLater();
    });
  }

  template<typename Fn, typename ProgressFn>
  inline void postBinary(const QString& path, const QByteArray data, const QString mimeType, Fn&& fn, ProgressFn&& progressFn) {
    QNetworkRequest request(homeserverURL + path);
    request.setHeader(QNetworkRequest::ContentTypeHeader, mimeType);
    request.setRawHeader("Authorization", accessToken.toLocal8Bit());

    request.setHeader(QNetworkRequest::ContentLengthHeader, QByteArray::number(data.size()));

    QNetworkReply* reply = manager->post(request, data);
    reply->connect(reply, &QNetworkReply::finished, [reply, fn] {
        fn(reply);
        reply->deleteLater();
    });
    QObject::connect(reply, &QNetworkReply::uploadProgress, progressFn);
  }

  template<typename Fn>
  inline void post(const QString& path, Fn&& fn) {
    QNetworkRequest request(homeserverURL + path);
    request.setRawHeader("Authorization", accessToken.toLocal8Bit());

    manager->post(request, QByteArray());
  }

  inline void post(const QString& path) {
    QNetworkRequest request(homeserverURL + path);
    request.setRawHeader("Authorization", accessToken.toLocal8Bit());

    manager->post(request, QByteArray());
  }

  inline void putJSON(const QString& path, const QJsonObject object) {
    QNetworkRequest request(homeserverURL + path);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", accessToken.toLocal8Bit());

    const QByteArray jsonPost = QJsonDocument(object).toJson();

    request.setHeader(QNetworkRequest::ContentLengthHeader, QByteArray::number(jsonPost.size()));

    manager->put(request, jsonPost);
  }

  template<typename Fn>
  inline void putJSON(const QString& path, const QJsonObject object, Fn&& fn) {
    QNetworkRequest request(homeserverURL + path);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", accessToken.toLocal8Bit());

    const QByteArray jsonPost = QJsonDocument(object).toJson();
    request.setHeader(QNetworkRequest::ContentLengthHeader, QByteArray::number(jsonPost.size()));

    QNetworkReply* reply = manager->put(request, jsonPost);
    reply->connect(reply, &QNetworkReply::finished, [reply, fn] {
        fn(reply);
        reply->deleteLater();
    });
  }

  template<typename Fn>
  inline void get(const QString& path, Fn&& fn, const QString contentType = "application/json") {
    QNetworkRequest request(homeserverURL + path);
    request.setHeader(QNetworkRequest::ContentTypeHeader, contentType);
    request.setRawHeader("Authorization", accessToken.toLocal8Bit());

    QNetworkReply* reply = manager->get(request);
    reply->connect(reply, &QNetworkReply::finished, [reply, fn] {
        fn(reply);
        reply->deleteLater();
    });
  }
}
