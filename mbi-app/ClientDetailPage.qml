import QtQuick 2.4

ClientDetailPageForm {

    function updateModel(data) {
        header_title.text = data.name
        //bloodtype_text.text = data.bloodtype
    }

}
