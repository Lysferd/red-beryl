import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0


/*******************************************************************************
  Exam Setup Page

    This UI object is responsible for...
*******************************************************************************/
Page {
    id: exam_setup_page
    anchors.fill: parent

    property alias segmentSelection: segmentSelection
    property alias cbItems: cbItems
    property alias codExam: codExam
    property alias codExamButton: codExamButton
    property alias codExamArea: codExamArea
    property alias exam_setup_page: exam_setup_page
    property alias body_area: body_area
    property alias body_highlight: body_highlight

    //property alias body_half_left: body_half_left
    //property alias body_half_right: body_half_right
    //property alias body_left_arm: body_left_arm
    //property alias body_right_arm: body_right_arm
    //property alias body_torax: body_torax

    /***************************************************************************
        Exam Setup Page :: Header
    ***************************************************************************/
    header: Rectangle {
        id: exam_setup_page_header

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
            id: exam_setup_page_header_title

            // Positioning //
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.leftMargin: 20 + 28 + 5

            // Title //
            text: "Configurar Exame"
            font.pixelSize: 30
        }

        /***********************************************************************
            Exam Setup Page :: Header :: Back Button
        ***********************************************************************/
        Button {
            id: exam_setup_page_header_back_button

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
                id: exam_setup_page_header_back_button_image

                width: parent.width - 6
                height: parent.width - 6
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                source: "../images/left_arrow_white.png"
                mipmap: true
            }

            ColorOverlay {
                anchors.fill: exam_setup_page_header_back_button_image
                source: exam_setup_page_header_back_button_image

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
        Exam Setup Page :: Pane
    ***************************************************************************/
    Pane {
        id: exam_setup_page_pane

        anchors.fill: parent
        background: Rectangle {
            color: "white"
        }

        Flickable {
            id: flickable
            anchors.fill: parent
            //height: parent.height - 10
            flickableDirection: Flickable.VerticalFlick

            contentHeight: column.height

            ScrollIndicator.vertical: ScrollIndicator {
            }

            Column {
                id: column
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                spacing: 8

                ComboBox {
                    id: segmentSelection
                    currentIndex: 0
                    width: 300
                    font.pointSize: 11
                    anchors.horizontalCenter: parent.horizontalCenter
                    model: ListModel {
                        id: cbItems
                        ListElement {
                            text: "Personalizado"
                        }
                        ListElement {
                            text: "Braço direito total"
                        }
                        ListElement {
                            text: "Braço esquerdo total"
                        }
                        ListElement {
                            text: "Corpo todo, lado direito"
                        }
                        ListElement {
                            text: "Corpo todo, lado esquerdo"
                        }
                        ListElement {
                            text: "Tórax"
                        }
                    }
                }

                Row {
                    id: codExamArea
                    width: segmentSelection.width
                    height: 40
                    spacing: segmentSelection.width * 0.02
                    anchors.horizontalCenter: segmentSelection.horizontalCenter

                    TextField {
                        id: codExam
                        width: parent.width * 0.77
                        height: 40
                        placeholderText: "Digite um código"
                        font.letterSpacing: 3
                        font.capitalization: Font.AllUppercase
                    }

                    Button {
                        id: codExamButton
                        text: "ok"
                        width: parent.width * 0.20
                        height: 40
                    }
                }

                Rectangle {
                    id: body_area
                    width: parent.width
                    height: exam_setup_page.height * 0.55
                    color: "#FFFFFF"

                    Image {
                        id: body_image
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        source: "../images/body_full_white.png"
                        mipmap: true
                        z: 1
                    }

                    ColorOverlay {
                        anchors.fill: body_image
                        source: body_image
                        z: 1
                        color: "#037BFB"
                    }

                    Image {
                        id: body_highlight
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        source: "../images/body_transp.png"
                        mipmap: true
                        z: 2
                    }

                    /*
                    Image {
                        id: body_half_left
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        source: "../images/body_half_left_red.png"
                        mipmap: true
                        z: 0
                    }

                    Image {
                        id: body_half_right
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        source: "../images/body_half_right_red.png"
                        mipmap: true
                        z: 0
                    }

                    Image {
                        id: body_left_arm
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        source: "../images/body_left_arm_red.png"
                        mipmap: true
                        z: 0
                    }

                    Image {
                        id: body_right_arm
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        source: "../images/body_right_arm_red.png"
                        mipmap: true
                        z: 0
                    }

                    Image {
                        id: body_torax
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        source: "../images/body_torax_red.png"
                        mipmap: true
                        z: 0
                    }
                    */
                }

                Button {
                    id: button
                    text: qsTr("Iniciar Exame")
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
