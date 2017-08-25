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


    //spacing: 0
    font.capitalization: Font.AllLowercase
    font.weight: Font.ExtraLight

    anchors.fill: parent

    property alias back_button: client_detail_page_header_back_button
    property alias header_title: client_detail_page_header_title
    property alias code: client_detail_page_code
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

        /***********************************************************************
            Client Details Page :: Header :: Back Button
        ***********************************************************************/
        Button {
            id: client_detail_page_header_back_button
            width: parent.height * 0.7
            height: parent.height * 0.9

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: parent.height * 0.1
            anchors.leftMargin: parent.width * 0.03

            //text: "Voltar"
            flat: true

            Image {
                id: client_detail_page_header_back_button_image

                width: parent.height * 0.7
                height: parent.height * 0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                source: "images/left_arrow_white.png"
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

            // Positioning //
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: parent.height * 0.2
            anchors.leftMargin: parent.width * 0.3

            // Title //
            font.pixelSize: parent.height * 0.5
        }

        /***********************************************************************
            Client Details Page :: Header :: Edit Button
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

    Rectangle {
        x: 0
        y: 0
        color: "white"
        anchors.fill: parent

        ScrollView {
            id: scrollView
            anchors.fill: parent
            ScrollIndicator.vertical: ScrollIndicator

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
                        id: client_detail_page_code
                        text: "<dummy>"
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
                        id: client_detail_page_dateReg
                        text: "<dummy>"
                        font.pixelSize: 12
                        height: 15
                    }
                    Label {
                        id: label2
                        text: qsTr("Data de Nascimento")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }

                    Text {
                        id: client_detail_page_birthday
                        text: qsTr("<dummy>")
                        font.pixelSize: 12
                        height: 15
                    }

                    Label {
                        id: label8
                        text: qsTr("RG")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }

                    Text {
                        id: client_detail_page_idDoc
                        text: qsTr("<dummy>")
                        font.pixelSize: 12
                        height: 15
                    }
                    Label {
                        id: label19
                        text: qsTr("Última Consulta")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }

                    Text {
                        id: client_detail_page_lastConsultation
                        text: qsTr("<dummy>")
                        font.pixelSize: 12
                        height: 15
                    }
                }

                //bottom line//
                Rectangle {
                    id: rectangleble
                    width: scrollView.width - 16
                    height: 1
                    color: "lightgray"
                }

                ColumnLayout {
                    id: columnLayout2
                    width: parent.width
                    height: 100
                    Label {
                        id: label3
                        text: qsTr("Ficha Clínica")
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
                        id: client_detail_page_bloodtype
                        text: "<dummy>"
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
                        id: client_detail_page_age
                        text: qsTr("<dummy>")
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
                        id: client_detail_page_height
                        text: qsTr("<dummy>")
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
                        id: client_detail_page_weight
                        text: qsTr("<dummy>")
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
                        id: client_detail_page_imc
                        text: qsTr("<dummy>")
                        font.pixelSize: 12
                        height: 15
                    }
                    Label {
                        id: label18
                        text: qsTr("GRUPOS DE RISCO")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }

                    Text {
                        id: client_detail_page_riskGroups
                        text: qsTr("<dummy>")
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
                        id: client_detail_page_regularlyMedicines
                        text: qsTr("<dummy>")
                        font.pixelSize: 12
                        height: 15
                    }

                    spacing: 5
                }

                //bottom line//
                Rectangle {
                    id: rectangleble2
                    width: scrollView.width - 16
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
                        id: client_detail_page_analysis1_bodyLocation
                        text: qsTr("<dummy>")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }
                    Label {
                        id: client_detail_page_analysis1_date
                        text: qsTr("<dummy>")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }
                    Text {
                        id: client_detail_page_analysis1_values
                        text: qsTr("<dummy>")
                        font.pixelSize: 12
                        height: 15
                    }

                    Label {
                        id: client_detail_page_analysis2_bodyLocation
                        text: qsTr("<dummy>")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }
                    Label {
                        id: client_detail_page_analysis2_date
                        text: qsTr("<dummy>")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }
                    Text {
                        id: client_detail_page_analysis2_values
                        text: qsTr("<dummy>")
                        font.pixelSize: 12
                        height: 15
                    }

                    Label {
                        id: client_detail_page_analysis3_bodyLocation
                        text: qsTr("<dummy>")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }
                    Label {
                        id: client_detail_page_analysis3_date
                        text: qsTr("<dummy>")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }
                    Text {
                        id: client_detail_page_analysis3_values
                        text: qsTr("<dummy>")
                        font.pixelSize: 12
                        height: 15
                    }
                    Label {
                        id: client_detail_page_analysis4_bodyLocation
                        text: qsTr("<dummy>")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }
                    Label {
                        id: client_detail_page_analysis4_date
                        text: qsTr("<dummy>")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }
                    Text {
                        id: client_detail_page_analysis4_values
                        text: qsTr("<dummy>")
                        font.pixelSize: 12
                        height: 15
                    }
                    Label {
                        id: client_detail_page_analysis5_bodyLocation
                        text: qsTr("<dummy>")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }
                    Label {
                        id: client_detail_page_analysis5_date
                        text: qsTr("<dummy>")
                        font.capitalization: Font.AllUppercase
                        height: 15
                    }
                    Text {
                        id: client_detail_page_analysis5_values
                        text: qsTr("<dummy>")
                        font.pixelSize: 12
                        height: 15
                    }

                    spacing: 5
                }
            }
        }
    }
}
