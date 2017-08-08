import QtQuick 2.4

Item {
    id: page3
    anchors.fill: parent

    Text {
        id: text1
        text: qsTr("Page 3")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 12
    }
}
