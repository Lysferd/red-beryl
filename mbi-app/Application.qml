import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

Page {
    anchors.fill: parent

    opacity: 0.0
    Behavior on opacity { NumberAnimation { duration: 500 } }

    function init() { opacity = 1.0 }

    StackLayout {
        anchors.fill: parent
        currentIndex: tabmenu.tabBar.currentIndex

        Item {

            ClientPage {
                id: client_page

                Pane {
                    id: client_page_pane

                    anchors.fill: parent
                    background: Rectangle { color: "white" }

                    ClientView {
                        id: client_view

                        onPressAndHold: {
                            currentClient = index
                            beterraba.open()
                        }
                    }
                }
            }
        }

        Item { DevicePage {} }
        Item { CloudPage {} }
        Item { SettingsPage {} }
    }

    footer: TabMenu { id: tabmenu }

    /*
    Menu {
        id: beterraba
        modal: true
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2

        Label {
            padding: 10
            font.bold: true
            width: parent.width
            horizontalAlignment: Qt.AlignHCenter
            text: currentClient >= 0 ? client_view.model.get(currentClient).name : ""
        }

        Label {
            padding: 10
            font.bold: true
            width: parent.width
            horizontalAlignment: Qt.AlignHCenter
            text: index
        }

        MenuItem {
            text: qsTr("Edit")
            //onTriggered: contactDialog.editContact(contactView.model.get(currentContact))
        }

        MenuItem {
            text: qsTr("Remove")
            //onTriggered: contactView.model.remove(currentContact)
        }

        MenuItem {
            text: qsTr("Quit")
            onTriggered: Qt.quit()
        }

    }*/
}
