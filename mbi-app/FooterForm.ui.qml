import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: item1
    width: 300
    height: 100
    property alias tabBar: tabBar
    property alias rowLayout: rowLayout
    transformOrigin: Item.Center

    RowLayout {
        id: rowLayout
        x: 0
        y: 50
        width: 300
        height: 48
        spacing: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        scale: 1
        transformOrigin: Item.Bottom

        TabBar {
            id: tabBar
            width: 300
            height: 48
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true

            TabButton {
                id: tabButton
                height: 48
                text: qsTr("試し")
                checked: true
            }

            TabButton {
                id: tabButton1
                text: qsTr("終了")
            }
        }
    }
}
