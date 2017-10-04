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

                source: "images/left_arrow_white.png"
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
                spacing: 15

                Button {
                    id: button
                    width: 200
                    text: qsTr("Multifrequencial")
                    spacing: -4
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    id: rectangle
                    width: parent.width
                    height: 400
                    color: "#FFFFFF"

                    Image {
                        id: body_image
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        source: "images/humanbody_white.png"
                        mipmap: true
                    }

                    ColorOverlay {
                        anchors.fill: body_image
                        source: body_image

                        color: "#037BFB"
                    }
                }
                /*
                Button {
                    id: button1
                    width: 200
                    text: qsTr("2 canais, 8 pontos")
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: button2
                    width: 200
                    text: qsTr("Multiponto Segmentar")
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: button3
                    width: 200
                    text: qsTr("Multiponto Configurável")
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: button4
                    width: 200
                    text: qsTr("Corpo todo, um lado")
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: button5
                    width: 200
                    text: qsTr("Corpo todo, dois lados")
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: button6
                    width: 200
                    text: qsTr("Tórax")
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: button7
                    width: 200
                    text: qsTr("Tronco")
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: button8
                    width: 200
                    text: qsTr("dummy")
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: button9
                    width: 200
                    text: qsTr("dummy")
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: button10
                    width: 200
                    text: qsTr("dummy")
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: button11
                    width: 200
                    text: qsTr("dummy")
                    anchors.horizontalCenter: parent.horizontalCenter
                }*/
            }
        }
    }
}
