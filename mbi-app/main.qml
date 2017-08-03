import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 400
    height: 400
    title: qsTr("Red Beryl 1.0_preview")


    StackView {
        anchors.fill: parent
        //anchors.topMargin: 8
        //anchors.leftMargin: 8
        anchors.margins: 8

        initialItem: Page {
            //anchors.centerIn: parent
            width: parent.width * 0.1
            height: parent.height * 0.1
            background: Rectangle {
                color: "#00ff00"
            }

            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.5
                height: parent.height * 0.5
                color: "#ff0000"
            }
        }
    }

/*
    footer: Footer { }

    StackView {
        anchors.fill: parent

        initialItem: Content {
            //anchors.fill: parent

            //width: parent.width
            //height: parent.height
        }
    }
*/
}
