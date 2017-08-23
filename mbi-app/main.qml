import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true

    // Width and height proportional to iPhone screen.
    width: 750 / 2
    height: 1334 / 2
    title: qsTr("Red Beryl [GUI Preview]")

    property int currentClient: -1

    StackLayout {
        anchors.fill: parent
        currentIndex: repolho.tabBar.currentIndex

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

    footer: TabMenu {
        id: repolho
    }

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

    }
}
