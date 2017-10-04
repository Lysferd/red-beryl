import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0


/*******************************************************************************

  Settings Page

*******************************************************************************/
Page {
    id: settings_page

    font.weight: Font.ExtraLight

    anchors.fill: parent

    /***************************************************************************
        Settings Page :: Header
    ***************************************************************************/
    header: Rectangle {
        id: settings_page_header

        // Positioning & Sizes//
        width: parent.width
        height: parent.height * 0.1

        // Background Color //
        color: "#F7F7F7"

        /***********************************************************************
            Settings Page :: Header :: Header Title
        ***********************************************************************/
        Text {
            id: settings_page_header_title

            // Positioning //
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.leftMargin: 20

            // Title //
            text: "Opções"
            font.pixelSize: 30
        }

        /***********************************************************************
            Settings Page :: Header :: Settings Button
        ***********************************************************************/
        Button {
            id: settings_page_header_done_button

            width: parent.height * 0.7
            height: parent.height * 0.9

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: parent.height * 0.1
            anchors.rightMargin: parent.width * 0.03

            flat: true

            Image {
                id: settings_page_header_done_button_image

                width: parent.height * 0.7
                height: parent.height * 0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                source: "images/settings_white.png"
                mipmap: true
            }

            ColorOverlay {
                anchors.fill: settings_page_header_done_button_image
                source: settings_page_header_done_button_image

                color: "#037BFB"
            }
        }

        /***********************************************************************
            Settings Page :: Header :: Bottom Border
        ***********************************************************************/
        Rectangle {
            width: parent.width
            height: 2
            color: "#b2b2b2"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
        }
    }

    /***************************************************************************
        Settings Page :: Pane
    ***************************************************************************/
    Pane {
        id: settings_page_pane

        anchors.fill: parent
        background: Rectangle {
            color: "white"
        }

        Flickable {
            id: settings_page_pane_flickable

            anchors.fill: parent
            height: parent.height - 10
            flickableDirection: Flickable.VerticalFlick
            contentHeight: columnLayout1.height

            ScrollIndicator.vertical: ScrollIndicator {
            }

            ColumnLayout {
                id: columnLayout1
                //anchors.bottom: parent.bottom
                //anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                spacing: 4
                width: parent.width

                //Begin of Rectangle Row1
                Rectangle {
                    id: rectangle_row1
                    width: parent.width
                    height: 40
                    color: "#00000000"
                    Layout.fillWidth: true

                    Rectangle {
                        id: rectangle
                        width: 30
                        height: 30
                        color: "#00000000"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 30

                        Image {
                            id: option1_image
                            anchors.fill: parent
                            Layout.fillHeight: true
                            source: "images/chip_white.png"
                        }

                        ColorOverlay {
                            x: 205
                            y: -50
                            anchors.fill: option1_image
                            source: option1_image

                            color: "#037BFB"
                            Layout.fillHeight: false
                        }
                    }

                    Label {
                        id: label_name
                        text: "Configurar MBI"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 90
                        font.capitalization: Font.SmallCaps
                        fontSizeMode: Text.HorizontalFit
                        font.bold: true
                        height: 15
                        width: settings_page_pane.width / 2
                    }
                }
                //End of Rectangle Row1

                //Begin of Rectangle Line1
                Rectangle {
                    id: rectangle_line1
                    width: parent.width
                    height: 2
                    color: "lightgray"
                    Layout.fillWidth: true
                }
                //End of Rectangle Line1

                //Begin of Rectangle Row2
                Rectangle {
                    id: rectangle_row2
                    width: parent.width
                    height: 40
                    color: "#00000000"
                    Layout.fillWidth: true

                    Rectangle {
                        id: rectangle2
                        width: 30
                        height: 30
                        color: "#00000000"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 30

                        Image {
                            id: option2_image
                            anchors.fill: parent
                            Layout.fillHeight: true
                            source: "images/chip_white.png"
                        }

                        ColorOverlay {
                            x: 205
                            y: -50
                            anchors.fill: option2_image
                            source: option2_image

                            color: "#037BFB"
                            Layout.fillHeight: false
                        }
                    }

                    Label {
                        id: label_name2
                        text: "Configurar Nuvem"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 90
                        font.capitalization: Font.SmallCaps
                        fontSizeMode: Text.HorizontalFit
                        font.bold: true
                        height: 15
                        width: settings_page_pane.width / 2
                    }
                }
                //End of Rectangle Row2

                //Begin of Rectangle Line2
                Rectangle {
                    id: rectangle_line2
                    width: parent.width
                    height: 2
                    color: "lightgray"
                    Layout.fillWidth: true
                }
                //End of Rectangle Line2

                //Begin of Rectangle Row3
                Rectangle {
                    id: rectangle_row3
                    width: parent.width
                    height: 40
                    color: "#00000000"
                    Layout.fillWidth: true

                    Rectangle {
                        id: rectangle3
                        width: 30
                        height: 30
                        color: "#00000000"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 30

                        Image {
                            id: option3_image
                            anchors.fill: parent
                            Layout.fillHeight: true
                            source: "images/chip_white.png"
                        }

                        ColorOverlay {
                            x: 205
                            y: -50
                            anchors.fill: option3_image
                            source: option3_image

                            color: "#037BFB"
                            Layout.fillHeight: false
                        }
                    }

                    Label {
                        id: label_name3
                        text: "Configurar Cores"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 90
                        font.capitalization: Font.SmallCaps
                        fontSizeMode: Text.HorizontalFit
                        font.bold: true
                        height: 15
                        width: settings_page_pane.width / 2
                    }
                }
                //End of Rectangle Row3

                //Begin of Rectangle Line3
                Rectangle {
                    id: rectangle_line3
                    width: parent.width
                    height: 2
                    color: "lightgray"
                    Layout.fillWidth: true
                }
                //End of Rectangle Line3

                //Begin of Rectangle Row4
                Rectangle {
                    id: rectangle_row4
                    width: parent.width
                    height: 40
                    color: "#00000000"
                    Layout.fillWidth: true

                    Rectangle {
                        id: rectangle4
                        width: 30
                        height: 30
                        color: "#00000000"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 30

                        Image {
                            id: option4_image
                            anchors.fill: parent
                            Layout.fillHeight: true
                            source: "images/chip_white.png"
                        }

                        ColorOverlay {
                            x: 205
                            y: -50
                            anchors.fill: option4_image
                            source: option4_image

                            color: "#037BFB"
                            Layout.fillHeight: false
                        }
                    }

                    Label {
                        id: label_name4
                        text: "Personalizar Relatórios"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 90
                        font.capitalization: Font.SmallCaps
                        fontSizeMode: Text.HorizontalFit
                        font.bold: true
                        height: 15
                        width: settings_page_pane.width / 2
                    }
                }
                //End of Rectangle Row4

                //Begin of Rectangle Line4
                Rectangle {
                    id: rectangle_line4
                    width: parent.width
                    height: 2
                    color: "lightgray"
                    Layout.fillWidth: true
                }
                //End of Rectangle Line4

                //Begin of Rectangle Row5
                //End of Rectangle Row5

                //Begin of Rectangle Line5
                //End of Rectangle Line5

                //Begin of Rectangle Row6
            }
            //End of Rectangle Row6

            //Begin of Rectangle Line6
            //End of Rectangle Line6
        }
    }
}
