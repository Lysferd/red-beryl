import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0


/*******************************************************************************
  Client Page

    This UI object is responsible for drawing the list of registered entries,
 acquired from `ClientModel`, as well as allow creation of new entries,
 editting of existing entries, and search for keywords in the list.
*******************************************************************************/
Page {
    id: client_detail_page
    spacing: 0
    font.capitalization: Font.AllLowercase
    font.weight: Font.ExtraLight
    anchors.fill: parent

    /***************************************************************************
        Client Page :: Header
    ***************************************************************************/
    header: Rectangle {
        id: client_detail_page_header

        // Positioning & Sizes//
        // x:
        // y:
        width: parent.width
        height: parent.height * 0.1

        // Background Color //
        color: "#F7F7F7"

        // Border //
        border.width: 1
        border.color: "red" //"#b2b2b2"

        Text {
            id: client_detail_page_header_title
            text: "$NOME$"

            // Positioning //
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: parent.height * 0.2
            anchors.leftMargin: parent.width * 0.03

            // Title //
            font.pixelSize: parent.height * 0.5
        }

        /***********************************************************************
            Client Page :: Header :: Add Button
        ***********************************************************************/
        Button {
            id: client_detail_page_header_add_button

            width: parent.height * 0.7
            height: parent.height * 0.9

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: parent.height * 0.1
            anchors.rightMargin: parent.width * 0.03

            flat: true

            Image {
                id: client_detail_page_header_add_button_image

                width: parent.height * 0.7
                height: parent.height * 0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                source: "images/edit_white.png"
                mipmap: true
            }

            ColorOverlay {
                anchors.fill: client_detail_page_header_add_button_image
                source: client_detail_page_header_add_button_image

                color: "#037BFB"
            }
        }
    }

    ColumnLayout {
        id: columnLayout
        anchors.rightMargin: 8
        anchors.leftMargin: 8
        anchors.bottomMargin: 8
        anchors.topMargin: 8
        anchors.fill: parent
        ScrollIndicator.vertical: true

        ColumnLayout {
            id: columnLayout1
            height: 100
            spacing: 3
            width: parent.width

            Label {
                id: label
                text: qsTr("PRONTUÁRIO")
                font.capitalization: Font.AllUppercase
                height: 15
            }

            Text {
                id: text1
                text: qsTr("233164925")
                font.pixelSize: 12
                height: 15
            }

            Label {
                id: label1
                text: qsTr("DATA DO CADASTRAMENTO")
                font.capitalization: Font.AllUppercase
                height: 15
            }

            Text {
                id: text2
                text: qsTr("22 ABR 2011")
                font.pixelSize: 12
                height: 15
            }

            Label {
                id: label2
                text: qsTr("RG")
                font.capitalization: Font.AllUppercase
                height: 15
            }

            Text {
                id: text3
                text: qsTr("3.754.181-9")
                font.pixelSize: 12
                height: 15
            }
        }

        ColumnLayout {
            id: columnLayout2
            width: parent.width
            height: 100
            Label {
                id: label3
                text: qsTr("BIOTIPO")
                font.capitalization: Font.AllUppercase
                height: 15
            }

            Label {
                id: label9
                text: qsTr("TIPO SANGUÍNEO")
                font.capitalization: Font.AllUppercase
                height: 15
            }

            Text {
                id: text4
                text: "A+"
                font.pixelSize: 12
                height: 15
            }

            Label {
                id: label4
                text: qsTr("IDADE")
                font.capitalization: Font.AllUppercase
                height: 15
            }

            Text {
                id: text5
                text: qsTr("44 A 7 M 12 D")
                font.pixelSize: 12
                height: 15
            }

            Label {
                id: label5
                text: qsTr("altura")
                font.capitalization: Font.AllUppercase
                height: 15
            }

            Text {
                id: text6
                text: qsTr("1,64 M")
                font.pixelSize: 12
                height: 15
            }

            Label {
                id: label6
                text: qsTr("peso")
                font.capitalization: Font.AllUppercase
                height: 15
            }

            Text {
                id: text7
                text: qsTr("60 Kg")
                font.pixelSize: 12
                height: 15
            }
            Label {
                id: label7
                text: qsTr("imc")
                font.capitalization: Font.AllUppercase
                height: 15
            }

            Text {
                id: text8
                text: qsTr("22,31 (IDEAL)")
                font.pixelSize: 12
                height: 15
            }
            Label {
                id: label8
                text: qsTr("GRAU DE RISCO")
                font.capitalization: Font.AllUppercase
                height: 15
            }

            Text {
                id: text9
                text: qsTr("CARDÍACO, PRESSÃO ALTA")
                font.pixelSize: 12
                height: 15
            }

            spacing: 5
        }

        ColumnLayout {
            id: columnLayout3
            width: parent.width
            height: 100
            Label {
                id: label10
                text: qsTr("PRONTUÁRIO")
                font.capitalization: Font.AllUppercase
                height: 15
            }

            Text {
                id: text10
                text: qsTr("233164925\n")
                font.pixelSize: 12
                height: 15
            }

            Label {
                id: label11
                text: qsTr("DATA DO CADASTRAMENTO")
                font.capitalization: Font.AllUppercase
                height: 15
            }

            Text {
                id: text11
                text: qsTr("22 ABR 2011\n")
                font.pixelSize: 12
                height: 15
            }

            Label {
                id: label12
                text: qsTr("RG:")
                font.capitalization: Font.AllUppercase
                height: 15
            }

            Text {
                id: text12
                text: qsTr("3.754.181-9\n")
                font.pixelSize: 12
                height: 15
            }
            spacing: 3
        }
    }

    /***************************************************************************
        Client Page :: Pane
    ***************************************************************************/

    /***********************************************************************
            Client Page :: Pane :: List View
        ***********************************************************************/
}
