import QtQuick 2.4

ExamSetupPageForm {
    segmentSelection.onCurrentIndexChanged: {
        console.debug("[onCurrentIndexChanged]");
        console.debug("ID: ", segmentSelection.currentIndex);

        if(segmentSelection.currentIndex == 0){
            codExamArea.visible = true
            body_area.height = exam_setup_page.height * 0.55
            codExam.text = ""
            updateBody(0)
            console.debug("ComboBox Index 0");
        } else if(segmentSelection.currentIndex == 1){
            codExamArea.visible = false
            body_area.height = exam_setup_page.height * 0.63
            updateBody(1)
            console.debug("ComboBox Index 1");
        } else if(segmentSelection.currentIndex == 2){
            codExamArea.visible = false
            body_area.height = exam_setup_page.height * 0.63
            updateBody(2)
            console.debug("ComboBox Index 2");
        } else if(segmentSelection.currentIndex == 3) {
            codExamArea.visible = false
            body_area.height = exam_setup_page.height * 0.63
            updateBody(3)
            console.debug("ComboBox Index 3");
        } else if(segmentSelection.currentIndex == 4) {
            codExamArea.visible = false
            body_area.height = exam_setup_page.height * 0.63
            updateBody(4)
            console.debug("ComboBox Index 4");
        } else if(segmentSelection.currentIndex == 5) {
            codExamArea.visible = false
            body_area.height = exam_setup_page.height * 0.63
            updateBody(5)
            console.debug("ComboBox Index 5");
        }

    }

    codExamButton.onClicked: {
        var str = codExam.text.toUpperCase()

        if (str == "BD00"){
            updateBody(1)
        } else if (str == "BE00"){
            updateBody(2)
        } else if (str == "LD00"){
            updateBody(3)
        } else if (str == "LE00"){
            updateBody(4)
        } else if (str == "TX00"){
            updateBody(5)
        } else {
            updateBody(0)
            codExam.color= "red"
            codExam.text = "CÓDIGO INVÁLIDO"
            eTimer.start()
        }
    }

    Timer  {
            id: eTimer
            interval: 1300;
            running: false;
            repeat: false;
            onTriggered: { codExam.text = ""; codExam.color = "black" }
        }

    function updateBody(arg){
        if(arg == 0){
            body_highlight.source = "images/body_transp.png"
            console.debug("UpdateBody Arg 0");

        } else if(arg == 1){
            body_highlight.source = "images/body_right_arm_red.png"
            console.debug("UpdateBody Arg 1");
        } else if(arg == 2){
            body_highlight.source = "images/body_left_arm_red.png"
            console.debug("UpdateBody Arg 2");
        } else if(arg == 3) {
            body_highlight.source = "images/body_half_right_red.png"
            console.debug("UpdateBody Arg 3");
        } else if(arg == 4) {
            body_highlight.source = "images/body_half_left_red.png"
            console.debug("UpdateBody Arg 4");
        } else if(arg == 5) {
            body_highlight.source = "images/body_torax_red.png"
            console.debug("UpdateBody Arg 5");
        }
    }
}
