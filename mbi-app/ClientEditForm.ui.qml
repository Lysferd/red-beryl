import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0


/*******************************************************************************

  Client Edit Page

*******************************************************************************/
Page {
    id: client_edit_page

    //spacing: 0
    font.weight: Font.ExtraLight

    anchors.fill: parent

    property alias back_button: client_edit_page_header_back_button

    property alias header_title: client_edit_page_header_title /*
    property alias code: client_edit_page_code
    property alias dateReg: client_edit_page_dateReg
    property alias birthday: client_edit_page_birthday
    property alias idDoc: client_edit_page_idDoc
    property alias bloodtype: client_edit_page_bloodtype
    property alias age: client_edit_page_age
    property alias pHeight: client_edit_page_height
    property alias weight: client_edit_page_weight
    property alias imc: client_edit_page_imc
    property alias riskGroups: client_edit_page_riskGroups
    property alias regularlyMedicines: client_edit_page_regularlyMedicines

    /***************************************************************************
        Client Edit Page :: Header
    ***************************************************************************/
    header: Rectangle {
        id: client_edit_page_header

        // Positioning & Sizes//
        width: parent.width
        height: parent.height * 0.1

        // Background Color //
        color: "#F7F7F7"

        /***********************************************************************
            Client Edit Page :: Header :: Back Button
        ***********************************************************************/
        Button {
            id: client_edit_page_header_back_button
            width: parent.height * 0.7
            height: parent.height * 0.9

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: parent.height * 0.1
            anchors.leftMargin: parent.width * 0.03

            //text: "Voltar"
            flat: true

            Image {
                id: client_edit_page_header_back_button_image

                width: parent.height * 0.7
                height: parent.height * 0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                source: "images/left_arrow_white.png"
                mipmap: true
            }

            ColorOverlay {
                anchors.fill: client_edit_page_header_back_button_image
                source: client_edit_page_header_back_button_image

                color: "#037BFB"
            }
        }

        /***********************************************************************
            Client Edit Page :: Header :: Header Title
        ***********************************************************************/
        Text {
            id: client_edit_page_header_title
            text: "<dummy>"
            anchors.topMargin: 16

            // Positioning //
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.16

            // Title //
            font.pixelSize: parent.height * 0.5
        }

        /***********************************************************************
            Client Edit Page :: Header :: Edit Button
        ***********************************************************************/
        Button {
            id: client_edit_page_header_add_button

            width: parent.height * 0.7
            height: parent.height * 0.9

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: parent.height * 0.1
            anchors.rightMargin: parent.width * 0.03

            flat: true

            Image {
                id: client_edit_page_header_add_button_image

                width: parent.height * 0.7
                height: parent.height * 0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                source: "images/people_white.png"
                mipmap: true
            }

            ColorOverlay {
                anchors.fill: client_edit_page_header_add_button_image
                source: client_edit_page_header_add_button_image

                color: "#037BFB"
            }
        }

        /***********************************************************************
            Client Edit Page :: Header :: Bottom Border
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
        Client Edit Page :: Pane
    ***************************************************************************/
    Pane {
        id: client_edit_page_pane

        anchors.fill: parent
        background: Rectangle {
            color: "white"
        }

        Flickable {
            id: client_edit_page_pane_flickable

            anchors.fill: parent
            height: parent.height - 10
            flickableDirection: Flickable.VerticalFlick
            contentHeight: columnLayout.height

            ScrollIndicator.vertical: ScrollIndicator {
            }

            ColumnLayout {
                id: columnLayout
                anchors.right: parent.right
                anchors.left: parent.left
                spacing: 15
                anchors.rightMargin: 8
                anchors.leftMargin: 8

                RowLayout {
                    id: rowLayout
                    width: 100
                    height: 100
                    spacing: 10

                    Rectangle {
                        id: rectangle
                        width: 80
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0

                        color: "#037BFB"
                        radius: 8

                        Image {
                            id: client_edit_page_groupImage_clients
                            width: 80
                            height: 80
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            sourceSize.height: 42
                            sourceSize.width: 42
                            source: "images/people_white.png"
                            mipmap: true
                        }
                    }
                }
            }
        }
    }
}
