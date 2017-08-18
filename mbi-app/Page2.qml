import QtQuick 2.4

Page2Form {
    bluetooth_button.onClicked: {
        deviceFinder.startSearch()
    }
}
