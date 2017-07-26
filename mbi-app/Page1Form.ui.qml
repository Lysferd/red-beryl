import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    property alias textField1: textField1
    property alias button1: button1
    property alias button2: button2

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top

        RowLayout {

            TextField {
                id: textField1
                placeholderText: qsTr("Text Field")
            }

            Button {
                id: button1
                text: qsTr("Press Me")
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            id: button2
            text: qsTr("Version")
        }
    }
}
