
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

import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

PageStackWindow {
    initialPage: Page {
        orientationLock: PageOrientation.LockPortrait

        tools: ToolBarLayout {
            ButtonRow {
                anchors.left: parent.left 
                style: TabButtonStyle { } 
                TabButton { 
                    text: "Top" 
                    tab: tab1
                    onClicked: { 
                        listModel.category = ''
                        listmodel.page = 0
                    }
                }
                TabButton { 
                   text: "New" 
                   tab: tab2 
                   onClicked: {
                       listModel.category = '/new'
                       listModel.page = 0
                   }
                }
            }
            ToolIcon {
                anchors.right: parent.right
                iconId: 'toolbar-view-menu'
                onClicked: contextMenu.open()
            }
        }

        ContextMenu {
            id: contextMenu

            MenuLayout {
                MenuItem {
                    text: 'About Mustr'
                    onClicked: pageStack.push(aboutPage)
                }
            }
        }

        BusyIndicator {
            anchors.centerIn: parent
            running: visible
            visible: listModel.status === XmlListModel.Loading
        }

        ListView {
            id: listView
            property int imageItemHeight: 150

            header: Item {
                height: listModel.page == 0?0:listView.imageItemHeight
                width: parent.width

                Button {
                    id: lastPage
                    anchors.centerIn: parent
                    text: 'Previous page'
                    onClicked: listModel.page -= 1
                    visible: listModel.page > 0 && listModel.count > 0
                    width: parent.width * .5
                }
            }

            footer: Item {
                height: listView.imageItemHeight
                width: parent.width

                Button {
                    id: nextPage
                    anchors.centerIn: parent
                    text: 'Next page'
                    onClicked: listModel.page += 1
                    width: parent.width * .5
                    visible: listModel.count > 0
                }
            }

            anchors.fill: parent
            model: XmlListModel {
                id: listModel

                property int perPage: 20
                property int page: 0
                property string category: ''

                source: 'http://www.colourlovers.com/api/patterns' + category +'?numResults=' + perPage + '&resultOffset=' + (perPage * page)
                onSourceChanged: console.log('src: ' + source)
                query: '/patterns/pattern'

                XmlRole { name: 'title'; query: 'title/string()' }
                XmlRole { name: 'url'; query: 'imageUrl/string()' }
                XmlRole { name: 'username'; query: 'userName/string()' }
                XmlRole { name: 'website'; query: 'url/string()' }
            }

            delegate: Item {
                width: parent.width
                height: listView.imageItemHeight

                Image {
                    clip: true
                    anchors.fill: parent
                    anchors.margins: mouseArea.pressed?10:0
                    fillMode: Image.Tile

                    Behavior on anchors.margins {
                        PropertyAnimation {
                            duration: 100
                        }
                    }

                    source: url

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: {
                            previewPage.title = title;
                            previewPage.username = username;
                            previewPage.website = website;
                            previewPage.url = url;

                            pageStack.push(previewPage);
                        }
                    }

                    Rectangle {
                        anchors {
                            right: parent.right
                            bottom: parent.bottom
                            margins: -10
                        }
                        width: credits.width + 20
                        height: credits.height + 20

                        color: '#80000000'
                        radius: 10

                        Label {
                            id: credits
                            anchors {
                                right: parent.right
                                bottom: parent.bottom
                                margins: 15
                            }
                            text: ' ' + title + ' by ' + username
                        }
                    }

                    BusyIndicator {
                        anchors.centerIn: parent
                        visible: parent.status === Image.Loading
                        running: visible
                    }
                }
            }
        }

        ScrollDecorator {
            flickableItem: listView
        }
    }

    Page {
        id: previewPage

        orientationLock: PageOrientation.LockPortrait

        tools: ToolBarLayout {
            ToolIcon {
                iconId: 'toolbar-back'
                onClicked: pageStack.pop()
            }
        }

        property string title: ''
        property string username: ''
        property string website: ''
        property string url: ''

        Image {
            anchors.fill: parent
            fillMode: Image.Tile
            source: previewPage.url
        }

        Rectangle {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            color: '#80000000'

            height: previewColumn.height + 2*previewColumn.anchors.margins

            Column {
                id: previewColumn

                anchors {
                    margins: 20
                    top: parent.top
                    left: parent.left
                }

                width: parent.width

                Label {
                    text: previewPage.title
                    font.bold: true
                    font.pixelSize: 30
                }

                Label {
                    text: 'by ' + previewPage.username
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally(previewPage.website)
            }
        }

        Button {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                margins: 20
            }

            text: 'Use as wallpaper'
            width: parent.width * .7
            onClicked: wallpaper.setPattern(previewPage.url)
        }

        InfoBanner {
            id: infoBanner
            text: 'Wallpaper was successfully set.'
        }

        Connections {
            target: wallpaper
            onDone: infoBanner.show()
        }
    }

    Page {
        id: aboutPage

        tools: ToolBarLayout {
            ToolIcon {
                iconId: 'toolbar-back'
                onClicked: pageStack.pop()
            }
        }

        Flickable {
            anchors.fill: parent
            contentHeight: aboutContainer.height
            contentWidth: aboutContainer.width

            Item {
                id: aboutContainer
                width: aboutPage.width
                height: aboutColumn.height

                Column {
                    id: aboutColumn

                    anchors {
                        left: parent.left
                        top: parent.top
                        right: parent.right
                        margins: 10
                    }

                    spacing: 10

                    Image {
                        source: 'file:///opt/mustr/mustr.png'
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Label {
                        text: 'Mustr 1.0.0'
                        font.pixelSize: 40
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Label {
                        text: 'Patterns everywhere!'
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Item {
                        width: 1
                        height: 50
                    }

                    Label {
                        text: 'Author: Thomas Perl\nLicense: GNU GPL v3 or later\nPatterns by COLOURlovers.com\nLicense of patterns: CC-BY-NC-SA\nhttp://thp.io/2012/mustr/\n\nInspired by Lucas Rocha\'s "Pattrn" app\nIcon by The Best Isaac'
                    }
                }
            }
        }
    }

    Component.onCompleted: theme.inverted = true
}

