import QtQuick 2.5
import QtQuick.Controls 2.2

Page {
    id: splash_page

    anchors.fill: parent

    opacity: 1.0
    Behavior on opacity { NumberAnimation { duration: 500 } }

    property bool _app_ready: false
    property bool _splash_ready: false
    property bool ready: _app_ready && _splash_ready

    signal readyToGo()

    function appReady() { _app_ready = true }
    function errorInLoadingApp() { Qt.quit() }
    function hide() { opacity = 0.0 }

    Image {
        anchors.centerIn: parent

        width: parent.width
        height: parent.height

        source: "images/splash.png"
    }

    Timer {
        id: splash_timer
        interval: 1000
        onTriggered: _splash_ready = true
    }

    onReadyChanged: if (ready) readyToGo();
    Component.onCompleted: splash_timer.start()
}
