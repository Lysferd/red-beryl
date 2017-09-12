import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0


/*******************************************************************************

  Client Edit Page

*******************************************************************************/
Page {
    id: client_edit_page

    font.weight: Font.ExtraLight

    anchors.fill: parent
    // Button Aliases
    property alias cancel_button: client_edit_page_header_cancel_button
    // Client Detail Aliases
    property alias client_name: client_edit_page_client_name
    property alias code: client_edit_page_code
    property alias dateReg: client_edit_page_dateReg
    property alias birthday: client_edit_page_birthday
    property alias idDoc: client_edit_page_idDoc
    property alias bloodtype: client_edit_page_bloodtype

    //property alias age: client_edit_page_age
    property alias pHeight: client_edit_page_height
    property alias weight: client_edit_page_weight

    //property alias imc: client_edit_page_imc
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
            Client Edit Page :: Header :: Header Title
        ***********************************************************************/
        Text {
            id: client_edit_page_header_title
            text: "Editar Paciente"
            anchors.topMargin: 16

            // Positioning //
            anchors.top: parent.top
            anchors.left: parent.left
            //anchors.leftMargin: parent.width * 0.16

            // Title //
            font.pixelSize: parent.height * 0.5
        }

        /***********************************************************************
            Client Edit Page :: Header :: Cancel Button
        ***********************************************************************/
        Button {
            id: client_edit_page_header_cancel_button

            width: parent.height * 0.7
            height: parent.height * 0.9

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: parent.height * 0.1
            anchors.rightMargin: parent.width * 0.03

            flat: true

            Image {
                id: client_edit_page_header_cancel_button_image

                width: parent.height * 0.7
                height: parent.height * 0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                source: "images/clear_white.png"
                mipmap: true
            }

            ColorOverlay {
                anchors.fill: client_edit_page_header_cancel_button_image
                source: client_edit_page_header_cancel_button_image

                color: "#037BFB"
            }
        }

        /***********************************************************************
            Client Edit Page :: Header :: Done Button
        ***********************************************************************/
        Button {
            id: client_edit_page_header_done_button

            width: parent.height * 0.7
            height: parent.height * 0.9

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: parent.height * 0.1
            anchors.rightMargin: parent.width * 0.16

            flat: true

            Image {
                id: client_edit_page_header_done_button_image

                width: parent.height * 0.7
                height: parent.height * 0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                source: "images/done_white.png"
                mipmap: true
            }

            ColorOverlay {
                anchors.fill: client_edit_page_header_done_button_image
                source: client_edit_page_header_done_button_image

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
                            id: columnLayout16
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label_name
                                text: "Nome Completo"
                                font.capitalization: Font.SmallCaps
                                fontSizeMode: Text.HorizontalFit
                                font.bold: true
                                height: 15
                                width: client_edit_page_pane.width / 2
                            }

                            TextField {
                                id: client_edit_page_client_name
                                selectionColor: "#00801c"
                                font.pixelSize: 12
                                selectByMouse: true
                                width: client_edit_page_client_name.contentWidth
                                       < 120 ? 120 : client_edit_page_client_name.contentWidth + 6
                                placeholderText: "Nome Completo"
                            }
                        }

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

                            TextField {
                                id: client_edit_page_code
                                selectionColor: "#00801c"
                                font.pixelSize: 12
                                selectByMouse: true
                                width: client_edit_page_code.contentWidth
                                       < 120 ? 120 : client_edit_page_code.contentWidth + 6
                                placeholderText: "Prontuário"
                            }
                        }

                        ColumnLayout {
                            id: columnLayout7
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label8
                                text: "CPF"
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                                height: 15
                            }

                            TextField {
                                id: client_edit_page_idDoc
                                text: "<dummy>"
                                inputMask: "999.999.999-99"
                                font.pixelSize: 12
                                height: 15
                                selectByMouse: true
                                width: client_edit_page_idDoc.contentWidth
                                       < 120 ? 120 : client_edit_page_idDoc.contentWidth
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

                            TextField {
                                id: client_edit_page_birthday
                                inputMask: "99/99/9999"
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                selectByMouse: true
                                width: client_edit_page_birthday.contentWidth
                                       < 120 ? 120 : client_edit_page_birthday.contentWidth + 6
                            }
                        }

                        ColumnLayout {
                            id: columnLayout5
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label1
                                text: "Data do Cadastro"
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                                height: 15
                            }

                            TextField {
                                inputMask: "99/99/9999"
                                id: client_edit_page_dateReg
                                font.pixelSize: 12
                                height: 15
                                selectByMouse: true
                                width: client_edit_page_dateReg.contentWidth
                                       < 120 ? 120 : client_edit_page_dateReg.contentWidth + 6
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

                            ComboBox {
                                id: client_edit_page_bloodtype
                                width: 120
                                height: 37

                                model: ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"]
                            }
                        }

                        /*ColumnLayout {
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

                            TextField {
                                id: client_edit_page_age
                                selectByMouse: true
                                inputMask: "D00"
                                font.pixelSize: 12
                                height: 15
                            }
                        }*/
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

                            TextField {
                                id: client_edit_page_height
                                selectByMouse: true
                                font.pixelSize: 12
                                height: 15
                                inputMask: "9,99 m"
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

                            TextField {
                                id: client_edit_page_weight
                                selectByMouse: true
                                font.pixelSize: 12
                                height: 15
                                inputMask: "D00 Kg"
                            }
                        }

                        /*ColumnLayout {
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

                            TextField {
                                id: client_edit_page_imc
                                selectByMouse: true
                                font.pixelSize: 12
                                height: 15
                                inputMask: "99,99"
                            }
                        }*/
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

                            TextField {
                                id: client_edit_page_riskGroups
                                selectByMouse: true
                                font.pixelSize: 12
                                height: 15
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

                            TextField {
                                id: client_edit_page_regularlyMedicines
                                selectByMouse: true
                                font.pixelSize: 12
                                height: 15
                            }
                        }

                        spacing: 5
                    }
                }

                RowLayout {
                    id: rowLayout2

                    Rectangle {
                        id: rectangle3

                        width: 80
                        radius: 8

                        anchors.top: parent.top
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0

                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: "#fc4f5b"
                            }

                            GradientStop {
                                position: 1
                                color: "#b0030c"
                            }
                        }

                        Image {
                            id: client_edit_page_groupImage_clinicalRecords1
                            width: 40
                            height: 40
                            anchors.verticalCenter: parent.verticalCenter
                            source: "images/delete_white.png"
                            anchors.horizontalCenter: parent.horizontalCenter
                            mipmap: true
                        }
                        anchors.bottom: parent.bottom
                    }

                    ColumnLayout {
                        id: columnLayout3
                        width: parent.width
                        height: 100

                        Button {
                            id: delete_button

                            text: "Excluir paciente"
                            font.capitalization: Font.Capitalize
                            flat: true

                            contentItem: Text {
                                text: delete_button.text
                                font: delete_button.font
                                color: "#FC0310"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }
                        }
                        spacing: 5
                    }
                    spacing: 10
                }
            }
        }
    }
}
