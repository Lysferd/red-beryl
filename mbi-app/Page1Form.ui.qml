import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Backend 1.0

Item {
    property alias textField1: textField1
    property alias button1: button1
    property alias textArea: textArea

    ColumnLayout {
        //anchors.fill: parent
        width: parent.width
        spacing: 1

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top

            TextField {
                id: textField1
                placeholderText: qsTr("query")
            }

            Button {
                id: button1
                text: qsTr("Query")
            }
        }

        TextArea {
            id: textArea
            text: qsTr("Text Area")
            rightPadding: 8
            leftPadding: 8
            horizontalAlignment: Text.AlignHCenter
            //Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            background: Rectangle {
                color: parent.focus ? "#000000" : "#ffffff"
            }
        }
    }

}
