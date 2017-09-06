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

    property alias header_title: client_edit_page_header_title
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
            text: "<dummy_edit>"
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

                        //color: "#037BFB"
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: "#4fa3fc"
                            }
                            GradientStop {
                                position: 1.0
                                color: "#0356b0"
                            }
                        }
                        radius: 8

                        Image {
                            id: client_detail_page_groupImage_clients
                            width: 80
                            height: 80
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "images/personal_data_white_big.png"
                            mipmap: true
                        }
                    }

                    ColumnLayout {
                        id: columnLayout1
                        height: 100
                        spacing: 9
                        width: parent.width

                        ColumnLayout {
                            id: columnLayout4
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label
                                text: "Prontuário"
                                font.capitalization: Font.SmallCaps
                                fontSizeMode: Text.HorizontalFit
                                font.bold: true
                                height: 15
                                width: client_edit_page_pane.width / 2
                            }

                            Rectangle {
                                width: client_edit_page_code.width
                                height: client_edit_page_code.height + 6
                                border.width: 1
                                border.color: "gray"

                                TextInput {
                                    anchors.verticalCenter: parent.verticalCenter
                                    id: client_edit_page_code
                                    text: "<dummy>"
                                    font.pixelSize: 12
                                    height: 15
                                    selectByMouse: true
                                    width: client_edit_page_code.contentWidth + 6 < 20 ? 20 : client_edit_page_code.contentWidth + 6
                                    x: 3
                                }
                            }


                        }

                        ColumnLayout {
                            id: columnLayout5
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label1
                                text: "Data do Cadastramento"
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                                height: 15
                            }

                            Rectangle {
                                width: client_edit_page_dateReg.width
                                height: client_edit_page_dateReg.height + 6
                                border.width: 1
                                border.color: "gray"

                                TextInput {
                                    anchors.verticalCenter: parent.verticalCenter
                                    id: client_edit_page_dateReg
                                    text: "<dummy>"
                                    font.pixelSize: 12
                                    height: 15
                                    selectByMouse: true
                                    width: client_edit_page_dateReg.contentWidth + 6 < 20 ? 20 : client_edit_page_dateReg.contentWidth + 6
                                    x: 3
                                }
                            }

                        }
                        ColumnLayout {
                            id: columnLayout6
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label2
                                text: "Data de Nascimento"
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                                height: 15
                            }

                            Rectangle {
                                width: client_edit_page_birthday.width
                                height: client_edit_page_birthday.height + 6
                                border.width: 1
                                border.color: "gray"

                                TextInput {
                                    anchors.verticalCenter: parent.verticalCenter
                                    id: client_edit_page_birthday
                                    text: "<dummy>"
                                    font.pixelSize: 12
                                    height: 15
                                    selectByMouse: true
                                    width: client_edit_page_birthday.contentWidth + 6 < 20 ? 20 : client_edit_page_birthday.contentWidth + 6
                                    x: 3
                                }
                            }
                        }

                        ColumnLayout {
                            id: columnLayout7
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label8
                                text: "Documento RG"
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                                height: 15
                            }

                            Rectangle {
                                width: client_edit_page_idDoc.width
                                height: client_edit_page_idDoc.height + 6
                                border.width: 1
                                border.color: "gray"

                                TextInput {
                                    anchors.verticalCenter: parent.verticalCenter
                                    id: client_edit_page_idDoc
                                    text: "<dummy>"
                                    font.pixelSize: 12
                                    height: 15
                                    selectByMouse: true
                                    width: client_edit_page_idDoc.contentWidth + 6 < 20 ? 20 : client_edit_page_idDoc.contentWidth + 6
                                    x: 3
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    id: rowLayout1
                    width: 100
                    height: 100
                    spacing: 10

                    Rectangle {
                        id: rectangle2
                        width: 80
                        //color: "#037BFB"
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: "#4fa3fc"
                            }
                            GradientStop {
                                position: 1.0
                                color: "#0356b0"
                            }
                        }
                        radius: 8
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0

                        Image {
                            id: client_edit_page_groupImage_clinicalRecords
                            width: 80
                            height: 80
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "images/clinical_data_white_big.png"
                            mipmap: true
                        }
                    }

                    ColumnLayout {
                        id: columnLayout2
                        width: parent.width
                        height: 100

                        ColumnLayout {
                            id: columnLayout9
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label9
                                text: "Tipo Sanguíneo"
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                                height: 15
                            }

                            Text {
                                id: client_edit_page_bloodtype
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                x: x + 10
                            }
                        }

                        ColumnLayout {
                            id: columnLayout10
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label4
                                text: "Idade"
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                                height: 15
                            }

                            Text {
                                id: client_edit_page_age
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                x: x + 10
                            }
                        }

                        ColumnLayout {
                            id: columnLayout11
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label5
                                text: "Altura"
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                                height: 15
                            }

                            Text {
                                id: client_edit_page_height
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                x: x + 10
                            }
                        }
                        ColumnLayout {
                            id: columnLayout12
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label6
                                text: "Peso"
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                                height: 15
                            }

                            Text {
                                id: client_edit_page_weight
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                x: x + 10
                            }
                        }

                        ColumnLayout {
                            id: columnLayout13
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label7
                                text: "IMC"
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                                height: 15
                            }

                            Text {
                                id: client_edit_page_imc
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                x: x + 10
                            }
                        }
                        ColumnLayout {
                            id: columnLayout14
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label18
                                text: "Grupos de Risco"
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                                height: 15
                            }

                            Text {
                                id: client_edit_page_riskGroups
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                x: x + 10
                            }
                        }
                        ColumnLayout {
                            id: columnLayout15
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label13
                                text: "Medicamentos Constantes"
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                                height: 15
                            }

                            Text {
                                id: client_edit_page_regularlyMedicines
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                x: x + 10
                            }
                        }

                        spacing: 5
                    }
                }
            }
        }
    }
}
