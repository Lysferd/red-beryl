import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

SwipeDelegate {
    checkable: true

    contentItem: ColumnLayout {

        Row {
            spacing: 8
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: circle_image

                width: 29
                height: width
                radius: width * 0.5
                color: ["lightblue", "lightgray", "lightgreen", "lightpink",
                    "lightcyan", "lightsteelblue", "lightcoral", "lightcyan",
                    "lightgoldenrodyellow", "lightsalmon", "lightseagreen"][Math.floor(Math.random() * 10)]

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: firstLetter
                    font.bold: true
                }
            }

            Label {
                anchors.verticalCenter: parent.verticalCenter
                text: "origin" //fullName
            }
        }
    }
}
