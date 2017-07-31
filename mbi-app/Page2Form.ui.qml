import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    width: 400
    height: 400

    StackLayout {
        id: stackLayout
        anchors.fill: parent
    }

    Text {
        id: text1
        x: 139
        y: 165
        text: qsTr("Abelha")
        font.pixelSize: 12
    }
}
