
from PySide.QtCore import *
from PySide.QtGui import *
from PySide.QtNetwork import *

dimensions = 480, 854
url = 'http://colourlovers.com.s3.amazonaws.com/images/patterns/582/582552.png'

app = QApplication([])

def on_finished(reply):
    pattern = QImage()
    pattern.load(reply, None)

    image = QImage(QSize(*dimensions), QImage.Format_ARGB32)
    painter = QPainter(image)
    painter.fillRect(image.rect(), QBrush(pattern))
    del painter
    image.save('test.png')

    app.quit()

nam = QNetworkAccessManager()
nam.finished.connect(on_finished)

nam.get(QNetworkRequest(QUrl(url)))

app.exec_()

