import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: item1
    clip: true

    Column {
        id: column
        anchors.fill: parent

        Row {
            id: row
            width: 540
            height: 99
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 50
            layoutDirection: Qt.LeftToRight

            Button {
                id: button
                width: 96
                height: 96
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
                width: 96
                height: 96
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

            Button {
                id: button2
                width: 96
                height: 96
                text: qsTr("")
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
                spacing: -3
                Text {
                    id: text4
                    x: 3
                    y: 71
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
