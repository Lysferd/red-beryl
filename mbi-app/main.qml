import QtQuick 2.7
import QtQuick.Controls 2.2

ApplicationWindow {
    visible: true

    // Width and height proportional to iPhone screen.
    width: 750 / 2
    height: 1334 / 2
    title: qsTr("Red Beryl [" + Qt.platform.os + "]")

    Loader {
        id: splash_loader
        anchors.fill: parent
        source: "SplashScreen.qml"
        asynchronous: false
        visible: true

        onStatusChanged: {
            if (status == Loader.Ready)
                application_loader.setSource("Application.qml")
        }
    }

    Loader {
        id: application_loader
        anchors.fill: parent
        visible: false
        asynchronous: false

        onStatusChanged: {
            if (status === Loader.Ready)
                splash_loader.item.appReady()
            if (status === Loader.Error)
                splash_loader.item.errorInLoadingApp()
        }
    }

    Connections {
        target: splash_loader.item

        onReadyToGo: {
            application_loader.visible = true
            application_loader.item.init()

            splash_loader.item.hide()
            splash_loader.setSource("")

            application_loader.item.forceActiveFocus()
        }
    }
}
