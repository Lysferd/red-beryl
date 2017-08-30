import QtQuick 2.0
import QtQuick.Controls 2.2

ListView {
    id: client_page_pane_listview

    anchors.fill: parent
    signal clicked(int index)

    ScrollIndicator.vertical: ScrollIndicator { }
    model: ClientModel { }
    delegate: ClientDelegate {
        id: client_page_pane_listview_clientdelegate
        width: parent.width
        height: 36

        Rectangle {
            y: parent.height
            height: 1
            width: parent.width
            color: "light gray"
        }

        Connections {
            target: client_page_pane_listview_clientdelegate
            onClicked: client_page_pane_listview.clicked(index)
        }
    }
}
