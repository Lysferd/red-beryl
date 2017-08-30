import QtQuick 2.0
import QtQuick.Controls 2.2

ListView {
    id: client_detail_page_pane_listview

    anchors.fill: parent

    ScrollIndicator.vertical: ScrollIndicator { }
    model: ClientModel { }
    delegate: DetailDelegate {
        id: client_detail_page_pane_listview_detaildelegate
        width: parent.width
        height: 36
    }
}
