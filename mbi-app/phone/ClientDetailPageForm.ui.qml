import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0


/*******************************************************************************
  Client Detail Page

    This UI object is mimicking a model that will be made in the next steps.

*******************************************************************************/
Page {
    id: client_detail_page

    font.capitalization: Font.AllLowercase
    font.weight: Font.ExtraLight
    anchors.fill: parent

    property int index
    // Button Aliases
    property alias back_button: client_detail_page_header_back_button
    property alias edit_button: client_detail_page_header_edit_button
    // Client Detail Aliases
    property alias header_title: client_detail_page_header_title
    property alias code: client_detail_page_code
    property alias fullName: client_detail_page_fullName
    property alias dateReg: client_detail_page_dateReg
    property alias birthday: client_detail_page_birthday
    property alias idDoc: client_detail_page_idDoc
    property alias lastConsultation: client_detail_page_lastConsultation
    property alias bloodtype: client_detail_page_bloodtype
    property alias age: client_detail_page_age
    property alias pHeight: client_detail_page_height
    property alias weight: client_detail_page_weight
    property alias imc: client_detail_page_imc
    property alias riskGroups: client_detail_page_riskGroups
    property alias regularlyMedicines: client_detail_page_regularlyMedicines

    property alias analysis1_bodyLocation: client_detail_page_analysis1_bodyLocation
    property alias analysis1_date: client_detail_page_analysis1_date
    property alias analysis1_values: client_detail_page_analysis1_values
    property alias analysis2_bodyLocation: client_detail_page_analysis2_bodyLocation
    property alias analysis2_date: client_detail_page_analysis2_date
    property alias analysis2_values: client_detail_page_analysis2_values
    property alias analysis3_bodyLocation: client_detail_page_analysis3_bodyLocation
    property alias analysis3_date: client_detail_page_analysis3_date
    property alias analysis3_values: client_detail_page_analysis3_values
    property alias analysis4_bodyLocation: client_detail_page_analysis4_bodyLocation
    property alias analysis4_date: client_detail_page_analysis4_date
    property alias analysis4_values: client_detail_page_analysis4_values
    property alias analysis5_bodyLocation: client_detail_page_analysis5_bodyLocation
    property alias analysis5_date: client_detail_page_analysis5_date
    property alias analysis5_values: client_detail_page_analysis5_values

    /***************************************************************************
        Client Detail Page :: Header
    ***************************************************************************/
    header: Rectangle {
        id: client_detail_page_header

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

        /***********************************************************************
            Client Details Page :: Header :: Back Button
        ***********************************************************************/
        Button {
            id: client_detail_page_header_back_button

            // Positioning //
            anchors.top: parent.top
            anchors.topMargin: 1
            anchors.left: parent.left
            anchors.leftMargin: 8

            // Sizes //
            width: 44
            height: 56

            // Flat button //
            flat: true

            Image {
                id: client_detail_page_header_back_button_image

                width: parent.width - 6
                height: parent.width - 6
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                source: "../images/left_arrow_white.png"
                mipmap: true
            }

            ColorOverlay {
                anchors.fill: client_detail_page_header_back_button_image
                source: client_detail_page_header_back_button_image

                color: "#037BFB"
            }
        }

        /***********************************************************************
            Client Details Page :: Header :: Header Title
        ***********************************************************************/
        Text {
            id: client_detail_page_header_title
            text: "<dummy>"
            fontSizeMode: Text.HorizontalFit
            verticalAlignment: Text.AlignVCenter

            // Positioning //
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.leftMargin: 20 + 28 + 5

            // Title //
            font.pixelSize: 30

            // Field Size //
            width: 200
            height: 36
            //clip: true
        }

        /***********************************************************************
            Client Details Page :: Header :: Edit Button
        ***********************************************************************/
        Button {
            id: client_detail_page_header_edit_button

            // Positioning //
            anchors.top: parent.top
            anchors.topMargin: 1
            anchors.right: parent.right
            anchors.rightMargin: 20

            // Sizes //
            width: 44
            height: 56

            // Flat button //
            flat: true

            Image {
                id: client_detail_page_header_edit_button_image

                width: parent.width - 6
                height: parent.width - 6
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                source: "../images/edit_white.png"
                mipmap: true
            }

            ColorOverlay {
                anchors.fill: client_detail_page_header_edit_button_image
                source: client_detail_page_header_edit_button_image

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
        Client Detail Page :: Pane
    ***************************************************************************/
    Pane {
        id: client_detail_page_pane

        anchors.fill: parent
        background: Rectangle {
            color: "white"
        }

        Flickable {
            id: client_detail_page_pane_flickable

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
                            source: "../images/personal_data_white_big.png"
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
                            }

                            Text {
                                id: client_detail_page_code
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }
                        }

                        ColumnLayout {
                            id: columnLayout21
                            width: 100
                            height: 100
                            spacing: 0
                            Label {
                                id: label3
                                height: 15
                                text: "Nome Completo"
                                fontSizeMode: Text.HorizontalFit
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                            }

                            Text {
                                id: client_detail_page_fullName
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                height: 15
                                text: "<dummy>"
                                font.pixelSize: 12
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

                            Text {
                                id: client_detail_page_dateReg
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
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

                            Text {
                                id: client_detail_page_birthday
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
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

                            Text {
                                id: client_detail_page_idDoc
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }
                        }

                        ColumnLayout {
                            id: columnLayout8
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: label19
                                text: "Última Consulta"
                                font.capitalization: Font.SmallCaps
                                font.bold: true
                                height: 15
                            }

                            Text {
                                id: client_detail_page_lastConsultation
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }
                        }
                    }
                }

                RowLayout {
                    id: rowLayout2
                    width: 100
                    height: 60
                    Rectangle {
                        id: rectangle1
                        width: 80
                        radius: 8
                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: "#4fa3fc"
                            }

                            GradientStop {
                                position: 1
                                color: "#0356b0"
                            }
                        }
                        Image {
                            id: client_detail_page_groupImage_clients1
                            width: 50
                            height: 50
                            anchors.horizontalCenter: parent.horizontalCenter
                            mipmap: true
                            anchors.verticalCenter: parent.verticalCenter
                            source: "../images/stethoscope_white.png"
                        }
                        anchors.top: parent.top
                        anchors.topMargin: 2
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 2
                    }

                    Button {
                        id: button
                        height: 30
                        width: 30
                        text: "Novo Exame"
                        Layout.fillWidth: true
                    }
                    spacing: 10
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
                            id: client_detail_page_groupImage_clinicalRecords
                            width: 80
                            height: 80
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "../images/clinical_data_white_big.png"
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
                                id: client_detail_page_bloodtype
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
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
                                id: client_detail_page_age
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
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
                                id: client_detail_page_height
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
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
                                id: client_detail_page_weight
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
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
                                id: client_detail_page_imc
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
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
                                id: client_detail_page_riskGroups
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
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
                                id: client_detail_page_regularlyMedicines
                                text: "<dummy>"
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }
                        }

                        spacing: 5
                    }
                }

                RowLayout {
                    id: rowLayout3
                    width: 100
                    height: 100
                    spacing: 10

                    Rectangle {
                        id: rectangle3
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
                            id: client_detail_page_groupImage_analyses
                            width: 80
                            height: 80
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "../images/measurement_data_white_big.png"
                            mipmap: true
                        }
                    }

                    ColumnLayout {
                        id: columnLayout3
                        width: parent.width
                        height: 100

                        Label {
                            id: label14
                            text: "Últimos Exames"
                            font.capitalization: Font.SmallCaps
                            font.bold: true
                            font.pointSize: 12
                            height: 15
                        }
                        ColumnLayout {
                            id: columnLayout16
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: client_detail_page_analysis1_date
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                height: 15
                            }

                            Label {
                                id: client_detail_page_analysis1_bodyLocation
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }

                            Text {
                                id: client_detail_page_analysis1_values
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }
                        }

                        ColumnLayout {
                            id: columnLayout17
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: client_detail_page_analysis2_date
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                height: 15
                            }

                            Label {
                                id: client_detail_page_analysis2_bodyLocation
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }

                            Text {
                                id: client_detail_page_analysis2_values
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }
                        }

                        ColumnLayout {
                            id: columnLayout18
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: client_detail_page_analysis3_date
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                height: 15
                            }

                            Label {
                                id: client_detail_page_analysis3_bodyLocation
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }

                            Text {
                                id: client_detail_page_analysis3_values
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }
                        }

                        ColumnLayout {
                            id: columnLayout19
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: client_detail_page_analysis4_date
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                height: 15
                            }

                            Label {
                                id: client_detail_page_analysis4_bodyLocation
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }

                            Text {
                                id: client_detail_page_analysis4_values
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }
                        }

                        ColumnLayout {
                            id: columnLayout20
                            width: 100
                            height: 100
                            spacing: 0

                            Label {
                                id: client_detail_page_analysis5_date
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                height: 15
                            }

                            Label {
                                id: client_detail_page_analysis5_bodyLocation
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }

                            Text {
                                id: client_detail_page_analysis5_values
                                text: "<dummy>"
                                font.capitalization: Font.SmallCaps
                                font.pixelSize: 12
                                height: 15
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }
                        }

                        spacing: 5
                    }
                }
            }
        }
    }
}
