import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: item1
    property alias columnLayout: columnLayout
    property alias rowLayout: rowLayout
    property alias rowLayout1: rowLayout1
    anchors.topMargin: -1
    transformOrigin: Item.Center
    opacity: 1
    clip: false

    ColumnLayout {
        id: columnLayout
        width: 320
        height: 280
        rotation: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        antialiasing: false
        transformOrigin: Item.Center
        spacing: 1

        RowLayout {
            id: rowLayout
            width: 100
            height: 100
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: false
            Layout.fillWidth: false
            transformOrigin: Item.Center
            spacing: 50

            Button {
                id: button
                Layout.maximumHeight: 150
                Layout.maximumWidth: 150
                Layout.minimumHeight: 100
                Layout.minimumWidth: 100
                Layout.preferredHeight: 100
                Layout.preferredWidth: 100
                text: qsTr("")
                spacing: -3

                Text {
                    id: text1
                    x: 23
                    y: 71
                    text: qsTr("Pacientes")
                    font.pixelSize: 12
                }

                Image {
                    id: image
                    x: 23
                    y: 15
                    width: 50
                    height: 50
                    source: "images/pacients.png"
                }
            }

            Button {
                id: button1
                Layout.maximumHeight: 150
                Layout.maximumWidth: 150
                Layout.minimumHeight: 100
                Layout.minimumWidth: 100
                Layout.preferredHeight: 100
                Layout.preferredWidth: 100
                text: qsTr("")
                spacing: -3
                Text {
                    id: text2
                    x: 7
                    y: 71
                    text: qsTr("Sincronizar MBI")
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 12
                }

                Image {
                    id: image1
                    x: 23
                    y: 15
                    width: 50
                    height: 50
                    source: "images/update.png"
                }
            }
        }

        RowLayout {
            id: rowLayout1
            width: 100
            height: 100
            Layout.fillHeight: false
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: 50

            Button {
                id: button2
                width: 96
                height: 96
                text: qsTr("")
                Layout.maximumHeight: 150
                Layout.maximumWidth: 150
                Layout.minimumHeight: 100
                Layout.minimumWidth: 100
                Layout.preferredHeight: 100
                Layout.preferredWidth: 100
                padding: 11
                font.weight: Font.ExtraLight
                spacing: -5
                Text {
                    id: text3
                    x: 16
                    y: 58
                    width: 65
                    height: 30
                    text: qsTr("Enviar para a Nuvem")
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideLeft
                    wrapMode: Text.WrapAnywhere
                    font.pixelSize: 12
                }

                Image {
                    id: image2
                    x: 23
                    y: 15
                    width: 50
                    height: 50
                    source: "images/cloud_upload.png"
                }
            }

            Button {
                id: button3
                width: 96
                height: 96
                text: qsTr("")
                Layout.maximumHeight: 150
                Layout.maximumWidth: 150
                Layout.minimumHeight: 100
                Layout.minimumWidth: 100
                Layout.preferredHeight: 100
                Layout.preferredWidth: 100
                spacing: -3
                Text {
                    id: text4
                    x: 3
                    y: 71
                    width: 92
                    text: qsTr("Contatar Suporte")
                    font.pixelSize: 12
                }

                Image {
                    id: image3
                    x: 23
                    y: 15
                    width: 50
                    height: 50
                    source: "images/support.png"
                }
            }
        }
    }
}
