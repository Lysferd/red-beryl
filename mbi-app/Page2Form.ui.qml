import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import Shared 1.0

Item {
    property alias bluetooth_button: bluetooth_button
    anchors.fill: parent

    property string errorMessage: deviceFinder.error
    property string infoMessage: deviceFinder.info

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#ffffff"

        Rectangle {
            id: rectangle
            y: parent.height * 0.2
            width: parent.width * 0.8
            height: parent.height * 0.4
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#F7F7F7"

            ListView {
                id: listView
                width: parent.width * 0.8
                height: parent.height * 0.9
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.1
                anchors.horizontalCenter: parent.horizontalCenter
                model: deviceFinder.devices

                delegate: Rectangle {
                    id: box
                    height: 40
                    Row {
                        id: row
                        spacing: 10

                        Text {
                            id: device
                            text: modelData.deviceName
                        }

                        Text {
                            id: deviceAddress
                            text: modelData.deviceAddress
                        }
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
            id: bluetooth_button
            flat: true
            width: parent.height * 0.7
            height: parent.height * 0.9
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.1
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.03

            enabled: !deviceFinder.scanning

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
                color: bluetooth_button.enabled ? "#037BFB" : "#929292"
            }
        }
    }
}
