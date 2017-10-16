import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    height: 32


    Rectangle {
        width: parent.width
        height: parent.height
        border.width: 1
        border.color: "#b2b2b2"
        color: "#F7F7F7"
    }
    RowLayout {
        id: rowLayout
        width: parent.width
        height: 32
    }
}
