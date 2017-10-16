import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import Shared 1.0

Item {
    id: page2
    anchors.fill: parent
    property alias page2: page2
    property alias bluetooth_button: bluetooth_button
    property string errorMessage: deviceFinder.error
    property string infoMessage: deviceFinder.info

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#ffffff"

        Pane {
            id: client_detail_page_pane
            x: 32
            y: 70

            anchors.fill: parent
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.1
            background: Rectangle {
                color: "white"
            }

            Flickable {
                id: client_detail_page_pane_flickable

                anchors.fill: parent
                height: parent.height - 10
                flickableDirection: Flickable.VerticalFlick
                contentHeight: columnLayout.height

                ScrollIndicator.vertical: ScrollIndicator {
                }

                ColumnLayout {
                    id: columnLayout
                    anchors.right: parent.right
                    anchors.left: parent.left
                    spacing: 15
                    anchors.rightMargin: 8
                    anchors.leftMargin: 8

                    RowLayout {
                        id: rowLayout
                        width: 100
                        height: 100
                        spacing: 10

                        Rectangle {
                            id: rectangle
                            width: 80
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.topMargin: 0
                            anchors.bottomMargin: 0

                            //color: "#037BFB"
                            gradient: Gradient {
                                GradientStop {
                                    position: 0.0
                                    color: "#4fa3fc"
                                }
                                GradientStop {
                                    position: 1.0
                                    color: "#0356b0"
                                }
                            }
                            radius: 8

                            Image {
                                id: client_detail_page_groupImage_clients
                                width: 80
                                height: 80
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: "../images/chip_white.png"
                                mipmap: true
                            }
                        }

                        ColumnLayout {
                            id: columnLayout1
                            height: 100
                            spacing: 9
                            width: parent.width

                            ColumnLayout {
                                id: columnLayout4
                                width: 100
                                height: 100
                                spacing: 0

                                Label {
                                    id: label
                                    text: "Nome do Dispositivo:"
                                    font.capitalization: Font.SmallCaps
                                    fontSizeMode: Text.HorizontalFit
                                    font.bold: true
                                    height: 15
                                }

                                Text {
                                    id: client_detail_page_code
                                    text: "<dummy>"
                                    font.pixelSize: 12
                                    height: 15
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                }
                            }

                            ColumnLayout {
                                id: columnLayout5
                                width: 100
                                height: 100
                                spacing: 0

                                Label {
                                    id: label1
                                    text: "Versão do software:"
                                    font.capitalization: Font.SmallCaps
                                    font.bold: true
                                    height: 15
                                }

                                Text {
                                    id: client_detail_page_dateReg
                                    text: "<dummy>"
                                    font.pixelSize: 12
                                    height: 15
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                }
                            }
                            ColumnLayout {
                                id: columnLayout6
                                width: 100
                                height: 100
                                spacing: 0

                                Label {
                                    id: label2
                                    text: "Versão do hardware:"
                                    font.capitalization: Font.SmallCaps
                                    font.bold: true
                                    height: 15
                                }

                                Text {
                                    id: client_detail_page_birthday
                                    text: "<dummy>"
                                    font.pixelSize: 12
                                    height: 15
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                }
                            }

                            ColumnLayout {
                                id: columnLayout7
                                width: 100
                                height: 100
                                spacing: 0

                                Label {
                                    id: label8
                                    text: "Baudrate:"
                                    font.capitalization: Font.SmallCaps
                                    font.bold: true
                                    height: 15
                                }

                                Text {
                                    id: client_detail_page_idDoc
                                    text: "<dummy>"
                                    font.pixelSize: 12
                                    height: 15
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                }
                            }

                            ColumnLayout {
                                id: columnLayout8
                                width: 100
                                height: 100
                                spacing: 0

                                Label {
                                    id: label19
                                    text: "Password:"
                                    font.capitalization: Font.SmallCaps
                                    font.bold: true
                                    height: 15
                                }

                                Text {
                                    id: client_detail_page_lastConsultation
                                    text: "<dummy>"
                                    font.pixelSize: 12
                                    height: 15
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                }
                            }

                            Rectangle {
                                id: rectangle_row6
                                width: parent.width
                                height: 40
                                color: "#00000000"
                                Layout.fillWidth: true

                                Rectangle {
                                    id: rectangle6
                                    width: 30
                                    height: 30
                                    color: "#00000000"
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 5

                                    Image {
                                        id: option6_image
                                        anchors.fill: parent
                                        Layout.fillHeight: true
                                        source: "../images/chip_white.png"
                                    }

                                    ColorOverlay {
                                        x: 205
                                        y: -50
                                        anchors.fill: option6_image
                                        source: option6_image

                                        color: "#037BFB"
                                        Layout.fillHeight: false
                                    }
                                }

                                Button {
                                    id: button2
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 160
                                    height: 40
                                    text: "Sincronizar"
                                    spacing: -2
                                    //flat: true
                                    anchors.left: parent.left
                                    anchors.leftMargin: 50

                                }

                            }

                            Rectangle {
                                id: rectangle_row7
                                width: parent.width
                                height: 40
                                color: "#00000000"
                                Layout.fillWidth: true
                                Rectangle {
                                    id: rectangle7
                                    width: 30
                                    height: 30
                                    color: "#00000000"
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    Image {
                                        id: option6_image1
                                        source: "../images/chip_white.png"
                                        anchors.fill: parent
                                        Layout.fillHeight: true
                                    }

                                    ColorOverlay {
                                        x: 205
                                        y: -50
                                        color: "#037bfb"
                                        source: option6_image1
                                        anchors.fill: option6_image1
                                        Layout.fillHeight: false
                                    }
                                    anchors.leftMargin: 5
                                }

                                Button {
                                    id: button3
                                    width: 160
                                    height: 40
                                    text: "Detalhes"
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: -2
                                    anchors.leftMargin: 50
                                }
                            }

                            Rectangle {
                                id: rectangle_row8
                                width: parent.width
                                height: 40
                                color: "#00000000"
                                Layout.fillWidth: true
                                Rectangle {
                                    id: rectangle8
                                    width: 30
                                    height: 30
                                    color: "#00000000"
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    Image {
                                        id: option6_image2
                                        source: "../images/chip_white.png"
                                        anchors.fill: parent
                                        Layout.fillHeight: true
                                    }

                                    ColorOverlay {
                                        x: 205
                                        y: -50
                                        color: "red"
                                        source: option6_image2
                                        anchors.fill: option6_image2
                                        Layout.fillHeight: false
                                    }
                                    anchors.leftMargin: 5
                                }

                                Button {
                                    id: button4
                                    width: 160
                                    height: 40
                                    text: "Desparear"
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: -2
                                    anchors.leftMargin: 50
                                }
                            }
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
                source: connectionHandler.alive ? "../images/bluetooth_white.png" : "../images/bluetooth_disabled.png"
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
