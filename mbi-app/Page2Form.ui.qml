import QtQuick 2.4

Item {
    id: page2
    anchors.fill: parent

    Text {
        id: text1
        text: qsTr("Page 2")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 12
    }
}
