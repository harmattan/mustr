#ifndef MUSTR_WALLPAPER_H
#define MUSTR_WALLPAPER_H

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
#include <QtNetwork>
#include <GConfItem>

#define MEEGO_SCREEN_WIDTH 480
#define MEEGO_SCREEN_HEIGHT 854
#define BACKGROUND_KEY "/desktop/meego/background/portrait/picture_filename"

class Wallpaper : public QObject {
    Q_OBJECT

    public:
        Wallpaper(QObject *parent=NULL)
            : QObject(parent),
              m_networkAccessManager(),
              m_backgroundItem(BACKGROUND_KEY)
        {
            connect(&m_networkAccessManager, SIGNAL(finished(QNetworkReply*)),
                    this, SLOT(finished(QNetworkReply*)));
        }

    public slots:
        void setPattern(QString url)
        {
            m_networkAccessManager.get(QNetworkRequest(QUrl(url)));
        }

        void finished(QNetworkReply *reply)
        {
            QImage pattern;
            pattern.load(reply, "PNG");
            QString base = QFileInfo(reply->url().path()).baseName();

            QImage image(MEEGO_SCREEN_WIDTH,
                    MEEGO_SCREEN_HEIGHT,
                    QImage::Format_ARGB32);

            QPainter *painter = new QPainter(&image);
            painter->fillRect(image.rect(), QBrush(pattern));
            delete painter;

            QDir dir(QDir::home().filePath("MyDocs/.wallpapers"));
            dir.mkpath(".");
            QString filename = dir.filePath("mustr_" + base + ".png");
            image.save(filename);
            m_backgroundItem.set(filename);
            emit done();

        }

    signals:
        void done();

    private:
        QNetworkAccessManager m_networkAccessManager;
        GConfItem m_backgroundItem;
};

#endif
