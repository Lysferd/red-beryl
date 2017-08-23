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

        ListView {
            id: listView
            width: parent.width * 0.9
            height: parent.height * 0.9
            anchors.top: parent.top
            anchors.topMargin: 70
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            //model: deviceFinder.devices
            model: ListModel {
                ListElement {
                    name: "Device1"
                    baudRate: "9600"
                    macAddress: "sl.af.ak.fd.kf.ad"
                    version: "1.4"
                    password: "12345"
                }
                ListElement {
                    name: "Brey"
                    baudRate: "9600"
                    macAddress: "iu.yw.go.ih.oi.u5"
                    version: "1.2"
                    password: "12345"
                }
                ListElement {
                    name: "Crey"
                    baudRate: "9600"
                    macAddress: "iu.yw.go.ih.oi.u5"
                    version: "1.2"
                    password: "12345"
                }
                ListElement {
                    name: "Drey"
                    baudRate: "9600"
                    macAddress: "iu.yw.go.ih.oi.u5"
                    version: "1.2"
                    password: "12345"
                }
            }

            delegate: Item {
                id: box
                width: parent.width
                height: 100

                Rectangle {
                    width: parent.width
                    height: 90
                    radius: 6
                    color: "#037BFB"

                    Column{
                        width: parent.width
                        height: parent.height
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.top: parent.top
                        anchors.topMargin: 3
                        spacing: 3

                        Row {
                            id: row
                            spacing: 15
                            //width: parent.width
                            //height: parent.height * 0.5

                            Text {
                                text: "Nome:" //modelData.deviceName
                                //anchors.verticalCenter: parent.verticalCenter
                                color: "#FFFFFF"
                            }

                            Text {
                                text: name //modelData.deviceName
                                //anchors.verticalCenter: parent.verticalCenter
                                color: "#FFFFFF"
                            }

                            Text {
                                text: macAddress //modelData.deviceAddress
                                //anchors.verticalCenter: parent.verticalCenter
                                color: "#FFFFFF"
                            }
                        }

                        Row {
                            spacing: 15
                            Text {
                                text: "Versão:"
                                color: "#FFFFFF"
                            }
                            Text {
                                text: version //modelData.deviceAddress
                                //anchors.verticalCenter: parent.verticalCenter
                                color: "#FFFFFF"
                            }
                        }
                        Row {
                            spacing: 15
                            Text {
                                text: "BaudRate:"
                                color: "#FFFFFF"
                            }
                            Text {
                                text: baudRate //modelData.deviceAddress
                                //anchors.verticalCenter: parent.verticalCenter
                                color: "#FFFFFF"
                            }
                        }
                        Row {
                            spacing: 15
                            Text {
                                text: "Password:"
                                color: "#FFFFFF"
                            }
                            Text {
                                text: password //modelData.deviceAddress
                                //anchors.verticalCenter: parent.verticalCenter
                                color: "#FFFFFF"
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
