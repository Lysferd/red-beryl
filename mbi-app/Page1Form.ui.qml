import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: page1
    property alias rectangleHeight: header.height
    property alias rectangleWidth: header.width
    anchors.fill: parent

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#ffffff"

        ListView {
            id: listView
            ScrollBar.vertical: ScrollBar { } //turn visible automatically the scrollbar
            width: parent.width
            height: parent.height * 0.9
            highlightRangeMode: ListView.NoHighlightRange
            spacing: 3
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.1 + 4
            model: ListModel {
                ListElement {
                    name: "Grey"
                    capital: "G"
                }

                ListElement {
                    name: "Fulano"
                    capital: "F"
                }

                ListElement {
                    name: "Siclano"
                    capital: "S"
                }

                ListElement {
                    name: "Beltrano"
                    capital: "B"
                }

                ListElement {
                    name: "Lorem"
                    capital: "L"
                }

                ListElement {
                    name: "Ipsum"
                    capital: "I"
                }

                ListElement {
                    name: "Sibilis"
                    capital: "S"
                }

                ListElement {
                    name: "Red"
                    capital: "R"
                }

                ListElement {
                    name: "Blue"
                    capital: "B"
                }

                ListElement {
                    name: "Green"
                    capital: "G"
                }

            }

            delegate: Item {
                x: 4 //creates a left-margin
                width: parent.width
                height: 46 //needs to fit an entire item (element1 size + element 2 size + etc)

                Column{
                    id: column1
                    spacing: 0
                    width: parent.width

                    Row {
                        id: row1
                        spacing: 10
                        height: 42

                        Rectangle {
                            width: parent.height -4
                            height: width
                            radius: width * 0.5
                            color: "#D3D3D3"

                            Text {
                                text: capital
                                font.pointSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.bold: true
                            }
                        }

                        Text {
                            text: name
                            anchors.verticalCenter: parent.verticalCenter
                            font.bold: true
                        }
                    }

                    Rectangle {
                        width: parent.width * 0.85
                        height: 1
                        color: "#D3D3D3"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                }
            }
        }
    }

    Rectangle {
        id: header
        y: -1
        x: -1
        width: parent.width + 2
        height: parent.height * 0.1 + 1
        border.width: 1
        border.color: "#b2b2b2"
        color: "#F7F7F7"

        Text {
            id: text1
            text: qsTr("Pacientes")
            font.pixelSize: parent.height * 0.5
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.1
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.03
        }

        Button {
            id: button
            flat: true
            width: parent.height * 0.7
            height: parent.height * 0.9
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.1
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.03

            Image {
                id: search_icon
                width: parent.height * 0.7
                height: parent.height * 0.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/search_white.png"
                mipmap: true
            }

            ColorOverlay {
                id: search_icon_overlay
                anchors.fill: search_icon
                source: search_icon
                color: "#037BFB"
            }
        }
    }
}
