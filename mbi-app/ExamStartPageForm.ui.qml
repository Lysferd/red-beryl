import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import Shared 1.0

Item {
    id: page2
    anchors.fill: parent

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
                contentHeight: columnLayout1.height

                ScrollIndicator.vertical: ScrollIndicator {
                }

                ColumnLayout {
                    id: columnLayout1
                    x: 8
                    y: 0
                    width: client_detail_page_pane.width
                    height: client_detail_page_pane.height
                    spacing: 30

                    Button {
                        id: button4
                        width: 250
                        height: 40
                        text: "Cadastrar Paciente"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Button {
                        id: button2
                        width: 250
                        height: 40
                        text: "Escolher Paciente"
                        Layout.alignment: Qt.AlignHCenter
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
            text: "Exame"
            font.pixelSize: parent.height * 0.5
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.2
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.03
        }
    }
}
