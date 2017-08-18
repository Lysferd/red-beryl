import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

import Shared 1.0

ApplicationWindow {
    visible: true

    // Width and height proportional to iPhone screen.
    width: 750 / 2
    height: 1334 / 2
    title: "Red Beryl [GUI Preview]"

    StackLayout {
        anchors.fill: parent
        currentIndex: repolho.tabBar.currentIndex
        Item { Page1 {} }
        Item { Page2 {} }
        Item { Page3 {} }
        Item { Page4 {} }
    }

    footer: TabMenu {
        id: repolho
    }
}
