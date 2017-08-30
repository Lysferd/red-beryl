import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

ItemDelegate {
    checkable: false

    contentItem: ColumnLayout {

        Row {
            spacing: 8
            anchors.verticalCenter: parent.verticalCenter

            Label {
                anchors.verticalCenter: parent.verticalCenter
                text: "pangareh"
            }
        }
    }
}
