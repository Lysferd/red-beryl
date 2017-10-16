import QtQuick 2.0
import QtQuick.Controls 2.2
import "."

ListView {
    id: client_page_pane_listview

    anchors.fill: parent
    signal clicked(int index)

    ScrollIndicator.vertical: ScrollIndicator { }
    model: DataModel
    delegate: ClientDelegate {
        id: delegate
        width: parent.width
        height: 36

        swipe.right: Rectangle {
            width: parent.width
            height: parent.height
            clip: true
            color: SwipeDelegate.pressed ? "#555" : "#666"
            Label {
                   font.family: "Fontello"
                   text: delegate.swipe.complete ? "\ue805" // icon-cw-circled
                                                 : "\ue801" // icon-cancel-circled-1

                   padding: 20
                   anchors.fill: parent
                   horizontalAlignment: Qt.AlignRight
                   verticalAlignment: Qt.AlignVCenter

                   opacity: 2 * -delegate.swipe.position

                   color: Material.color(delegate.swipe.complete ? Material.Green : Material.Red, Material.Shade200)
                   Behavior on color { ColorAnimation { } }
               }

               Label {
                   text: qsTr("Removed")
                   color: "white"

                   padding: 20
                   anchors.fill: parent
                   horizontalAlignment: Qt.AlignLeft
                   verticalAlignment: Qt.AlignVCenter

                   opacity: delegate.swipe.complete ? 1 : 0
                   Behavior on opacity { NumberAnimation { } }
               }

               SwipeDelegate.onClicked: delegate.swipe.close()
               SwipeDelegate.onPressedChanged: undoTimer.stop()
        }

        Timer {
            id: undoTimer
            interval: 3600
            onTriggered: client_page_pane_listview.model.remove(index)
        }

        swipe.onCompleted: undoTimer.start()


        Rectangle {
            y: parent.height
            height: 1
            width: parent.width
            color: "light gray"
        }

        Connections {
            target: delegate
            onClicked: client_page_pane_listview.clicked(index)
        }
    }

    remove: Transition {
        SequentialAnimation {
            PauseAnimation { duration: 125 }
            NumberAnimation { property: "height"; to: 0; easing.type: Easing.InOutQuad }
        }
    }

    displaced: Transition {
        SequentialAnimation {
            PauseAnimation { duration: 125 }
            NumberAnimation { property: "y"; easing.type: Easing.InOutQuad }
        }
    }

}
