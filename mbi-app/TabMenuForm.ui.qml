import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: tabmenu
    height: 48
    property alias tabBar: tabBar

    StackLayout {
        id: stackLayout
        width: parent.width

        TabBar {
            id: tabBar
            spacing: 0
            currentIndex: 0
            background: Rectangle {
                x: -1
                width: parent.width + 2
                height: parent.height + 1
                border.width: 1
                border.color: "#b2b2b2"
                color: "#F7F7F7"
            }

            TabButton {
                id: tabButton1
                height: 48

                Image {
                    id: image1
                    width: 32
                    height: 32
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    sourceSize.width: 0
                    fillMode: Image.Stretch
                    source: "images/pacients.png"
                }

                Text {
                    id: text1
                    text: qsTr("Pacientes")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 12
                    color: parent.activeFocus ? "#037BFB" : "#929292"
                }
            }

            TabButton {
                id: tabButton2
                height: 48

                Text {
                    id: text2
                    text: qsTr("Atualizar")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 12
                    color: parent.activeFocus ? "#037BFB" : "#929292"
                }

                Image {
                    id: image2
                    width: 32
                    height: 32
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "images/update.png"
                }
            }

            TabButton {
                id: tabButton3
                height: 48

                Image {
                    id: image3
                    width: 32
                    height: 32
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "images/cloud_upload.png"
                }

                Text {
                    id: text3
                    text: qsTr("Sincronizar")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 12
                    color: parent.activeFocus ? "#037BFB" : "#929292"
                }
            }

            TabButton {
                id: tabButton4
                height: 48

                Image {
                    id: image4
                    width: 32
                    height: 32
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "images/support.png"
                }

                Text {
                    id: text4
                    text: qsTr("Suporte")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 12
                    color: parent.activeFocus ? "#037BFB" : "#929292"
                }
            }
        }
    }
}
