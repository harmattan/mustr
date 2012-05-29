#ifndef MUSTR_WALLPAPER_H
#define MUSTR_WALLPAPER_H

#include <QtGui>
#include <QtNetwork>

class Wallpaper : public QObject {
    Q_OBJECT

    public:
        Wallpaper(QObject *parent=NULL)
            : QObject(parent),
              m_networkAccessManager()
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
            pattern.load(reply, NULL);

            QImage image(480, 854, QImage::Format_ARGB32);
            QPainter *painter = new QPainter(&image);
            painter->fillRect(image.rect(), QBrush(pattern));
            delete painter;
            image.save("test.png");

            emit imageSaved();
        }

    signals:
        void imageSaved();

    private:
        QNetworkAccessManager m_networkAccessManager;
};

#endif
