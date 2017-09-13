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
                                source: "images/chip_white.png"
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
                                    x: x + 10
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
                                    x: x + 10
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
                                    x: x + 10
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
                                    x: x + 10
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
                                    x: x + 10
                                }
                            }

                            RowLayout {
                                id: rowLayout2
                                width: parent.width
                                height: 100

                                Button {
                                    id: device_page_form_button1
                                    flat: true
                                    text: "Sincronizar"

                                    contentItem: Text {
                                        text: device_page_form_button1.text
                                        font: device_page_form_button1.font
                                        //color: "#FC0310"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        elide: Text.ElideRight
                                    }
                                }

                                Button {
                                    id: device_page_form_button2
                                    flat: true
                                    text: "Detalhes"

                                    contentItem: Text {
                                        text: device_page_form_button2.text
                                        font: device_page_form_button2.font
                                        //color: "#FC0310"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        elide: Text.ElideRight
                                    }
                                }

                                Button {
                                    id: device_page_form_button3
                                    flat: true
                                    text: "Desparear"

                                    contentItem: Text {
                                        text: device_page_form_button3.text
                                        font: device_page_form_button3.font
                                        color: "#FC0310"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        elide: Text.ElideRight
                                    }
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
                source: connectionHandler.alive ? "images/bluetooth_white.png" : "images/bluetooth_disabled.png"
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
