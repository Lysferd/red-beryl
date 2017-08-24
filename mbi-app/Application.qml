import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

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
            Component {
                id: comp1

                ClientPage {
                    id: client_page

                    client_page_pane_clientview.onClicked: {
                        loader1.active = false
                        loader2.active = true
                        loader2.item.updateModel(client_page_pane_clientview.model.get(index))
                    }
                }
            }

            Component {
                id: comp2

                ClientDetailPage {
                    back_button.onClicked: {
                        loader1.active = true
                        loader2.active = false
                    }
                }
            }

            Loader {
                id: loader1
                active: true
                anchors.fill: parent
                sourceComponent: comp1
            }

            Loader {
                id: loader2
                active: false
                anchors.fill: parent
                sourceComponent: comp2
            }

        }
        Item { DevicePage {} }
        Item { CloudPage {} }
        Item { SettingsPage {} }
    }

    footer: TabMenu { id: tabmenu }
}
