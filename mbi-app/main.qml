import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 480
    height: 320
    title: qsTr("Red Beryl")

    SwipeView {
        id: swipeView
        anchors.fill: parent
        Page1 {
            id: page1
        }
    }
}
