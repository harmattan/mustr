
/**
 * Mustr: Pattern downloader from COLOURlovers.com for MeeGo Harmattan
 * Copyright (C) 2012  Thomas Perl
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **/

#include <QtGui>
#include <QtDeclarative>

#include "wallpaper.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QDeclarativeView view;

    Wallpaper *wallpaper = new Wallpaper(&view);
    view.rootContext()->setContextProperty("wallpaper", wallpaper);
    view.setSource(QUrl("qrc:/mustr.qml"));

#if defined(MEEGO_EDITION_HARMATTAN)
    view.showFullScreen();
#else
    view.show();
#endif

    return app.exec();
}

