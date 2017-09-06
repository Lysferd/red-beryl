import QtQuick 2.4

ClientEditForm {
    function updateModel(data) {
        header_title.text = data.name
        code.text = data.code
        dateReg.text = data.dateReg
        birthday.text = data.birthday
        idDoc.text = data.idDoc
        bloodtype.text = data.bloodtype
        age.text = data.age

        pHeight.text = data.pHeight
        weight.text = data.weight
        imc.text = data.imc
        riskGroups.text = data.riskGroups
        regularlyMedicines.text = data.regularlyMedicines
    }

}
