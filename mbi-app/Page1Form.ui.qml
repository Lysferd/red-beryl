import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: page1
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "#ffffff"
    }

    TextField {
        id: textField
        x: 0
        width: parent.width - 16
        text: qsTr("Search")
        anchors.horizontalCenter: parent.horizontalCenter
        font.italic: true
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: 0
    }
}
