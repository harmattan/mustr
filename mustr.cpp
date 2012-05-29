
#include <QtGui>

#include "wallpaper.h"

#define URL \
    "http://colourlovers.com.s3.amazonaws.com/images/patterns/582/582552.png"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    Wallpaper wallpaper;
    wallpaper.setPattern(URL);
    QObject::connect(&wallpaper, SIGNAL(imageSaved()),
            &app, SLOT(quit()));

    return app.exec();
}

