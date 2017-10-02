import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: tabmenu_item
    property alias tabBar: tabBar

    height: 48

    TabBar {
        id: tabBar

        width: parent.width
        currentIndex: 0
        spacing: 0

        TabButton {
            height: 48

            Image {
                id: pacientes_img
                width: 32
                height: 32
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.width: 0
                fillMode: Image.Stretch
                source: "images/people_white.png"
                mipmap: true
            }

            ColorOverlay {
                id: pacients_overlay
                anchors.fill: pacientes_img
                source: pacientes_img
                color: tabBar.currentIndex == 0 ? "#037BFB" : "#929292"
            }

            Text {
                id: text1
                text: qsTr("Pacientes")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 12
                color: tabBar.currentIndex == 0 ? "#037BFB" : "#929292"
            }
        }

        TabButton {
            id: tabButton2
            height: 48

            Text {
                id: text2
                text: "Exames"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 12
                color: tabBar.currentIndex == 1 ? "#037BFB" : "#929292"
            }

            Image {
                id: exames_img
                width: 32
                height: 32
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/stethoscope_white.png"
                mipmap: true
            }
            ColorOverlay {
                id: exames_overlay
                anchors.fill: exames_img
                source: exames_img
                color: tabBar.currentIndex == 1 ? "#037BFB" : "#929292"
            }
        }

        TabButton {
            id: tabButton3
            height: 48

            Image {
                id: configs_img
                width: 32
                height: 32
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/settings_white.png"
                mipmap: true
            }

            ColorOverlay {
                id: configs_overlay
                anchors.fill: configs_img
                source: configs_img
                color: tabBar.currentIndex == 3 ? "#037BFB" : "#929292"
            }

            Text {
                id: text4
                text: qsTr("Opções")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 12
                color: tabBar.currentIndex == 3 ? "#037BFB" : "#929292"
            }
        }
    }

    /***********************************************************************
        Client Details Page :: Header :: Bottom Border
    ***********************************************************************/
    Rectangle {
        width: parent.width
        height: 1
        color: "#b2b2b2"
        anchors.top: parent.top
        anchors.topMargin: 0
    }
}
