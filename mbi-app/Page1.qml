import QtQuick 2.7

Page1Form {
    button1.onClicked: {
        console.log("Button Pressed. Entered text: " + textField1.text);
    }

    button2.onClicked: {
        console.log(Application.version);
    }
}
