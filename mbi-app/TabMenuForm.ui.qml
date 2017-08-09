import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

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
                    id: pacientes_img
                    width: 32
                    height: 32
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    sourceSize.width: 0
                    fillMode: Image.Stretch
                    source: "images/ic_people_white_48px.svg"
                }
                ColorOverlay {
                    id: pacients_overlay
                    anchors.fill: pacientes_img
                    source: pacientes_img
                    color: parent.activeFocus ? "#037BFB" : "#929292"
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
                    text: qsTr("Medidor")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 12
                    color: parent.activeFocus ? "#037BFB" : "#929292"
                }

                Image {
                    id: medidor_img
                    width: 32
                    height: 32
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "images/ic_devices_white_48px.svg"
                }
                ColorOverlay {
                    id: medidor_overlay
                    anchors.fill: medidor_img
                    source: medidor_img
                    color: parent.activeFocus ? "#037BFB" : "#929292"
                }
            }

            TabButton {
                id: tabButton3
                height: 48

                Image {
                    id: nuvem_img
                    width: 32
                    height: 32
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "images/ic_cloud_white_48px.svg"
                }
                ColorOverlay {
                    id: nuvem_overlay
                    anchors.fill: nuvem_img
                    source: nuvem_img
                    color: parent.activeFocus ? "#037BFB" : "#929292"
                }

                Text {
                    id: text3
                    text: qsTr("Nuvem")
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
                    id: configs_img
                    width: 32
                    height: 32
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "images/ic_settings_white_48px.svg"
                }
                ColorOverlay {
                    id: configs_overlay
                    anchors.fill: configs_img
                    source: configs_img
                    color: parent.activeFocus ? "#037BFB" : "#929292"
                }

                Text {
                    id: text4
                    text: qsTr("Configurações")
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
