import QtQuick 2.7
import QtQuick.Controls 2.2

Menu {
    modal: true

    Label {
        padding: 10
        font.bold: true
        width: parent.width
        horizontalAlignment: Qt.AlignHCenter
        text: "derp" //currentContact >= 0 ? contactView.model.get(currentContact).fullName : ""
    }

    Label {
        padding: 10
        font.bold: true
        width: parent.width
        horizontalAlignment: Qt.AlignHCenter
        text: index
    }

    MenuItem {
        text: currentClient
        //onTriggered: contactDialog.editContact(contactView.model.get(currentContact))
    }

    MenuItem {
        text: qsTr("derpinoso")
        //onTriggered: contactView.model.remove(currentContact)
    }

    MenuItem {
        text: qsTr("Vá embora!!!1")
        onTriggered: Qt.quit()
    }

}
