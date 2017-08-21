import QtQuick 2.4
import Shared 1.0

Page2Form {
    bluetooth_button.onClicked: {
        deviceFinder.startSearch()
    }

    Component.onCompleted: {
        page2.hostModeChanged.connect
    }


}
