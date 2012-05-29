
TEMPLATE = app

QT += network declarative
CONFIG += link_pkgconfig
PKGCONFIG += gq-gconf

DEPENDPATH += .
INCLUDEPATH += .

HEADERS += wallpaper.h
SOURCES += mustr.cpp
RESOURCES += mustr.qrc

target.path = /opt/mustr/bin
INSTALLS += target

icon.path = /opt/mustr
icon.files = mustr.png
INSTALLS += icon

desktop.path = /usr/share/applications
desktop.files = mustr.desktop
INSTALLS += desktop

