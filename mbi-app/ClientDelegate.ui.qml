import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

ItemDelegate {
    checkable: true

    contentItem: Column {

        Row {
            spacing: 8
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: circle_image

                width: 28
                height: width
                radius: width * 0.5
                color: "light gray"

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    text: capital
                    font.bold: true
                }
            }

            Label {
                anchors.verticalCenter: parent.verticalCenter
                text: name
            }
        }
    }
}
