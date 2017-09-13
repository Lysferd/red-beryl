import QtQuick 2.4

ClientEditPageForm {

    function updateModel(model, index) {
        var data = model.get(index)

        client_name.text = data.firstName
        code.text = data.record
        dateReg.text = data.registerDate
        birthday.text = data.birthDate
        idDoc.text = data.personalId
        bloodtype.text = data.bloodType
        riskGroups.text = data.riskGroups
        regularlyMedicines.text = data.regularMedicines
    }

    function clean() {
        client_name.text = ""
        code.text = ""
        dateReg.text = ""
        birthday.text = ""
        idDoc.text = ""
        bloodtype.text = ""
        riskGroups.text = ""
        regularlyMedicines.text = ""
    }

}
