cmake_minimum_required(VERSION 2.8.12)
project(Trinity LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 COMPONENTS Core Quick Widgets WebEngine REQUIRED)

set(TRINITY_SRCS
    src/main.cpp
    src/eventmodel.cpp
    src/matrixcore.cpp
    src/emotelistmodel.cpp
    src/roomlistmodel.cpp
    src/membermodel.cpp
    src/communitylistmodel.cpp
    src/roomlistsortmodel.cpp
    src/settings.cpp)

set(TRINITY_HEADERS
    include/eventmodel.h
    include/matrixcore.h
    include/network.h
    include/room.h
    include/roomlistmodel.h
    include/desktop.h
    include/membermodel.h
    include/community.h
    include/communitylistmodel.h
    include/roomlistsortmodel.h
    include/emotelistmodel.h
    include/emote.h
    include/callobject.h
    include/settings.h)

add_executable(Trinity qml.qrc ${TRINITY_SRCS} ${TRINITY_HEADERS})

target_link_libraries(Trinity Qt5::Core Qt5::Quick Qt5::Widgets Qt5::WebEngine cmark)
target_include_directories(Trinity PRIVATE include)

install(TARGETS Trinity DESTINATION bin)
