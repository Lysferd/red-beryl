import QtQuick 2.4

ExamSetupPageForm {
    segmentSelection.onCurrentIndexChanged: {
        console.debug("[onCurrentIndexChanged]");
        console.debug("ID: ", segmentSelection.currentIndex);

        if(segmentSelection.currentIndex == 0){
            body_half_right.z = 0
            body_half_left.z = 0
            body_right_arm.z = 2
            body_left_arm.z = 0
            body_torax.z = 0
            console.debug("if 0");
        } else if(segmentSelection.currentIndex == 1) {
            body_half_right.z = 0
            body_half_left.z = 0
            body_right_arm.z = 0
            body_left_arm.z = 2
            body_torax.z = 0
            console.debug("if 1");
        } else if(segmentSelection.currentIndex == 2) {
            body_half_right.z = 2
            body_half_left.z = 0
            body_right_arm.z = 0
            body_left_arm.z = 0
            body_torax.z = 0
            console.debug("if 2");
        } else if(segmentSelection.currentIndex == 3) {
            body_half_right.z = 0
            body_half_left.z = 2
            body_right_arm.z = 0
            body_left_arm.z = 0
            body_torax.z = 0
            console.debug("if 3");
        } else if(segmentSelection.currentIndex == 4) {
            body_half_right.z = 0
            body_half_left.z = 0
            body_right_arm.z = 0
            body_left_arm.z = 0
            body_torax.z = 2
            console.debug("if 4");
        }



    }
}
