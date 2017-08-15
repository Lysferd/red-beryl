import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: page2
    property alias rectangleHeight: header.height
    property alias rectangleWidth: header.width
    anchors.fill: parent

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#ffffff"

        Rectangle {
            id: rectangle
            y: parent.height * 0.2
            width: parent.width * 0.8
            height: parent.height * 0.3
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#037BFB"

            ListView {
                id: listView
                width: parent.width * 0.8
                height: parent.height * 0.9
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                delegate: Item {
                    x: 5
                    width: parent.width
                    height: 20
                    Row {
                        id: row1
                        spacing: 50

                        Text {
                            text: prop
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#FFFFFF"
                        }

                        Text {
                            text: value
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#FFFFFF"
                        }
                    }
                }
                model: ListModel {
                    ListElement {
                        prop: "STATUS:"
                        value: "On-Line"
                    }

                    ListElement {
                        prop: "BATERIA:"
                        value: "67% (3h em stand by; 1h de medição"
                    }

                    ListElement {
                        prop: "CACHE:"
                        value: "4 medições não sincronizadas"
                    }

                    ListElement {
                        prop: "MODELO:"
                        value: "BX512"
                    }

                    ListElement {
                        prop: "SERIAL:"
                        value: "AETW649781154/2017"
                    }
                }
            }
        }
    }

    Rectangle {
        id: header
        y: -1
        x: -1
        width: parent.width + 2
        height: parent.height * 0.1 + 1
        border.width: 1
        border.color: "#b2b2b2"
        color: "#F7F7F7"

        Text {
            id: text1
            text: qsTr("Medidor")
            font.pixelSize: parent.height * 0.5
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.2
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.03
        }

        Button {
            id: button
            flat: true
            width: parent.height * 0.7
            height: parent.height * 0.9
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.1
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.03

            Image {
                id: devices_icon
                width: parent.height * 0.7
                height: parent.height * 0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/bluetooth_white.png"
                mipmap: true
            }

            ColorOverlay {
                id: devices_icon_overlay
                anchors.fill: devices_icon
                source: devices_icon
                color: "#037BFB"
            }
        }
    }
}
