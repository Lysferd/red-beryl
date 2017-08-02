import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: qsTr("Red Beryl - Preview")

    Page1 {
        visible: true
        width: 800
        height: 600
    }

    Page2 {
        visible: false
        width: 600
        height: 480

    }

}
