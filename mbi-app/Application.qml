import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

import Database 1.0

Page {
    anchors.fill: parent

    property int currentClient: -1

    opacity: 0.0
    Behavior on opacity { NumberAnimation { duration: 500 } }

    function init() { opacity = 1.0 }

    StackLayout {
        anchors.fill: parent
        currentIndex: tabmenu.tabBar.currentIndex

        Item {

            StackView {
                id: client_stack

                anchors.fill: parent

                focus: true

                initialItem: ClientPage {
                    id: client_page

                    client_list.onClicked: {
                        var data = client_list.model.get(index)

                        client_detail_page.updateModel(data)
                        client_stack.push(client_detail_page)
                    }

                    new_button.onClicked: {
                        client_stack.push(client_edit_page)
                    }
                }

                ClientDetailPage {
                    id: client_detail_page

                    visible: false

                    edit_button.onClicked: {
                        client_edit_page.updateModel(client_list.model.get(index))
                        client_stack.push(client_edit_page)
                    }

                    back_button.onClicked: client_stack.pop()
                }

                ClientEdit {
                    id: client_edit_page

                    visible: false

                    cancel_button.onClicked: client_stack.pop()
                }

                Keys.onReleased: if (event.key === Qt.Key_Back && client_stack.depth > 1) {
                                     client_stack.pop();
                                     event.accepted = true;
                                 }
            }
        }

        Item { DevicePage {} }
        Item { CloudPage {} }
        Item { SettingsPage {} }
    }

    footer: TabMenu { id: tabmenu }
}
