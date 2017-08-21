import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

ItemDelegate {
    checkable: true

    contentItem: ColumnLayout {
        Label {
            leftPadding: circle_image.width + 8
            anchors.verticalCenter: parent.verticalCenter

            text: name
            font.bold: true
        }
    }
}
