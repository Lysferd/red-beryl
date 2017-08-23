import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0


/*******************************************************************************
  Client Details Page

    This UI object is mimicking a model that will be made in the next steps.

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
        //border.width: 1
        //border.color: "red" //"#b2b2b2"
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
        //bottom border//
        Rectangle {
            width: parent.width
            height: 1
            color: "#b2b2b2"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
        }
    }

    Rectangle {
        x: 0
        y: 0
        color: "white"
        anchors.fill: parent

        ScrollView {
            id: scrollView
            anchors.fill: parent

            ColumnLayout {
                id: columnLayout
                x: 8
                //y: -40
                spacing: 15
                anchors.rightMargin: 8
                anchors.leftMargin: 8
                anchors.bottomMargin: 8
                anchors.topMargin: 8
                anchors.fill: parent

                ColumnLayout {
                    id: columnLayout1
                    height: 100
                    spacing: 5
                    width: parent.width

                    Label {
                        id: label17
                        text: qsTr("sobre o paciente")
                        font.bold: true
                        font.pointSize: 12
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }

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

                //bottom line//
                Rectangle {
                    id: rectangleble
                    width: scrollView.width-16
                    height: 1
                    color: "lightgray"
                }

                ColumnLayout {
                    id: columnLayout2
                    width: parent.width
                    height: 100
                    Label {
                        id: label3
                        text: qsTr("BIOTIPO")
                        font.pointSize: 12
                        font.bold: true
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
                    Label {
                        id: label13
                        text: qsTr("medicações constantes")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }

                    Text {
                        id: text13
                        text: qsTr("FUROSEMIDA, DALTEPARINA SÓDICA")
                        font.pixelSize: 12
                        height: 15
                    }

                    spacing: 5
                }

                //bottom line//
                Rectangle {
                    id: rectangleble2
                    width: scrollView.width-16
                    height: 1
                    color: "lightgray"
                }

                ColumnLayout {
                    id: columnLayout3
                    width: parent.width
                    height: 100
                    Label {
                        id: label14
                        text: qsTr("últimas medições")
                        font.bold: true
                        font.pointSize: 12
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }
                    Label {
                        id: label10
                        text: qsTr("antebraço direito")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }

                    Text {
                        id: text10
                        text: qsTr("12 U.M. | 15 U.M. | 12 U.M.")
                        font.pixelSize: 12
                        height: 15
                    }

                    Label {
                        id: label11
                        text: qsTr("braço direito")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }

                    Text {
                        id: text11
                        text: qsTr("12 U.M. | 15 U.M. | 12 U.M.")
                        font.pixelSize: 12
                        height: 15
                    }

                    Label {
                        id: label12
                        text: qsTr("antebraço esquerdo")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }

                    Text {
                        id: text12
                        text: qsTr("13 U.M. | 14 U.M. | 13 U.M.")
                        font.pixelSize: 12
                        height: 15
                    }
                    Label {
                        id: label15
                        text: qsTr("braço esquerdo")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }

                    Text {
                        id: text14
                        text: qsTr("11 U.M. | 11 U.M. | 13 U.M.")
                        font.pixelSize: 12
                        height: 15
                    }
                    Label {
                        id: label16
                        text: qsTr("caixa torácica")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }

                    Text {
                        id: text15
                        text: qsTr("23 U.M. | 28 U.M. | 24 U.M.")
                        font.pixelSize: 12
                        height: 15
                    }

                    spacing: 5
                }
            }
        }
    }

    /***************************************************************************
        Client Page :: Pane
    ***************************************************************************/

    /***********************************************************************
            Client Page :: Pane :: List View
        ***********************************************************************/
}
