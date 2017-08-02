import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 400
    height: 400
    title: qsTr("Red Beryl 1.0_preview")

    /*
    background: Rectangle {
        width: parent.width
        height: parent.height
        color: "#ff0000"
    }
    */

    footer: Footer { }

    StackView {
        anchors.fill: parent

        initialItem: Content {
            //anchors.fill: parent

            //width: parent.width
            //height: parent.height
        }
    }

}
