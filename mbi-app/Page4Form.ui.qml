import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: page4
    property alias rectangleHeight: header.height
    property alias rectangleWidth: header.width
    anchors.fill: parent

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#ffffff"
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
            text: qsTr("Configurações")
            font.pixelSize: parent.height * 0.5
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.1
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
                id: settings_icon
                width: parent.height * 0.7
                height: parent.height * 0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/settings_white.png"
                mipmap: true
            }

            ColorOverlay {
                id: settings_overlay
                anchors.fill: settings_icon
                source: settings_icon
                color: "#037BFB"
            }
        }
    }
}
