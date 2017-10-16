import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0


/*******************************************************************************
  Client Page

    This UI object is responsible for drawing the list of registered entries,
 acquired from `ClientModel`, as well as allow creation of new entries,
 editting of existing entries, and search for keywords in the list.
*******************************************************************************/
Page {
    id: client_page
    anchors.fill: parent

    property alias new_button: client_page_header_add_button
    property alias client_list: client_page_pane_clientview

    /***************************************************************************
        Client Page :: Header
    ***************************************************************************/
    header: Rectangle {
        id: client_page_header

        // Positioning & Sizes//
        width: parent.width
        height: parent.height * 0.1

        // Background Color //
        color: "#F7F7F7"

        //Ruler - Red horizontal Line
        /*Rectangle {
            width: parent.width
            height: 1
            color: "red"
            anchors.verticalCenter: parent.verticalCenter
            z: 1
        }*/
        Text {
            id: client_page_header_title

            // Positioning //
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.leftMargin: 20

            // Title //
            text: "Pacientes"
            font.pixelSize: 30
        }

        /***********************************************************************
            Client Page :: Header :: Search Button
        ***********************************************************************/
        Button {
            id: client_page_header_search_button

            // Positioning //
            anchors.top: parent.top
            anchors.topMargin: 3
            anchors.right: parent.right
            anchors.rightMargin: 20 + 28 + 25

            // Sizes //
            width: 44
            height: 56

            // Flat button //
            flat: true

            Image {
                id: client_page_header_search_button_image

                width: parent.width - 6
                height: parent.width - 6
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                source: "../images/search_white.png"
                mipmap: true
            }

            ColorOverlay {
                anchors.fill: client_page_header_search_button_image
                source: client_page_header_search_button_image

                color: "#037BFB"
            }
        }

        /***********************************************************************
            Client Page :: Header :: Add Button
        ***********************************************************************/
        Button {
            id: client_page_header_add_button

            // Positioning //
            anchors.top: parent.top
            anchors.topMargin: 3
            anchors.right: parent.right
            anchors.rightMargin: 20

            // Sizes //
            width: 44
            height: 56

            // Flat button //
            flat: true

            Image {
                id: client_page_header_add_button_image

                width: parent.width - 6
                height: parent.width - 6
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                source: "../images/add_white.png"
                mipmap: true
            }

            ColorOverlay {
                anchors.fill: client_page_header_add_button_image
                source: client_page_header_add_button_image

                color: "#037BFB"
            }
        }

        /***********************************************************************
            Client Details Page :: Header :: Bottom Border
        ***********************************************************************/
        Rectangle {
            width: parent.width
            height: 1
            color: "#b2b2b2"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
        }
    }

    /***************************************************************************
        Client Page :: Pane
    ***************************************************************************/
    Pane {
        id: client_page_pane

        anchors.fill: parent
        background: Rectangle {
            color: "white"
        }

        ClientView {
            id: client_page_pane_clientview
        }
    }
}
