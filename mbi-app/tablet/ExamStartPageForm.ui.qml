import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import Shared 1.0


/*******************************************************************************
  Exam Start Page

    This UI object is responsible for...
*******************************************************************************/
Page {
    id: page2
    anchors.fill: parent

    /***************************************************************************
        Exam Start Page :: Header
    ***************************************************************************/
    header: Rectangle {
        id: exam_start_page_header

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
            id: exam_start_page_header_title

            // Positioning //
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.leftMargin: 20

            // Title //
            text: "Novo Exame"
            font.pixelSize: 30
        }

        /***********************************************************************
            Exam Start Page :: Header :: Bottom Border
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
        Exam Start Page :: Pane
    ***************************************************************************/
    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#ffffff"

        Pane {
            id: client_detail_page_pane

            //x: 32
            // y: 70
            anchors.fill: parent
            anchors.top: parent.top
            anchors.topMargin: 0 //parent.height * 0.1
            background: Rectangle {
                color: "white"
            }

            Flickable {
                id: client_detail_page_pane_flickable

                height: parent.height - 10
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                flickableDirection: Flickable.VerticalFlick
                contentHeight: columnLayout1.height

                ScrollIndicator.vertical: ScrollIndicator {
                }

                ColumnLayout {
                    id: columnLayout1
                    anchors.bottomMargin: 70
                    anchors.topMargin: 70
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: parent.top
                    spacing: 30

                    RowLayout {
                        id: rowLayout

                        width: parent.width
                        height: 60
                        spacing: 10

                        Rectangle {
                            id: rectangle

                            width: 80
                            height: 60
                            radius: 8
                            //anchors.top: parent.top
                            //anchors.bottom: parent.bottom
                            anchors.topMargin: 0
                            anchors.bottomMargin: 0

                            gradient: Gradient {

                                GradientStop {
                                    color: "#4fa3fc"
                                    position: 0.0
                                }

                                GradientStop {
                                    color: "#0356b0"
                                    position: 1.0
                                }
                            }

                            Image {
                                id: client_detail_page_groupImage_clients

                                width: 50
                                height: 50
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: "../images/personal_data_white_big.png"
                                mipmap: true
                            }
                        }

                        Button {
                            id: button4
                            width: 250
                            height: 40
                            text: "Cadastrar Paciente"
                            padding: 27
                            Layout.minimumWidth: 250
                        }
                    }

                    RowLayout {
                        id: rowLayout1
                        width: parent.width
                        height: 60
                        Rectangle {
                            id: rectangle1
                            width: 80
                            height: 60
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
                                source: "../images/personal_data_white_big.png"
                            }
                            //anchors.top: parent.top
                            //anchors.topMargin: 0
                            //anchors.bottom: parent.bottom
                            //anchors.bottomMargin: 0
                        }

                        Button {
                            id: button2
                            width: 250
                            height: 40
                            text: "Escolher Paciente"
                            padding: 27
                            Layout.minimumWidth: 250
                        }

                        spacing: 10
                    }
                }
            }
        }
    }
}
