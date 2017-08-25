import QtQuick 2.4

ClientDetailPageForm {

    function updateModel(data) {
        header_title.text = data.name
        code.text = data.code
        dateReg.text = data.dateReg
        birthday.text = data.birthday
        idDoc.text = data.idDoc
        lastConsultation.text = data.lastConsultation
        bloodtype.text = data.bloodtype
        age.text = data.age
        height.text = data.height
        weight.text = data.weight
        imc.text = data.imc
        riskGroups.text = data.riskGroups
        regularlyMedicines.text = data.regularlyMedicines
        analysis1_bodyLocation.text = data.analysis1_bodyLocation
        analysis1_date.text = data.analysis1_date
        analysis1_values.text = data.analysis1_values
        analysis2_bodyLocation.text = data.analysis2_bodyLocation
        analysis2_date.text = data.analysis2_date
        analysis2_values.text = data.analysis2_values
        analysis3_bodyLocation.text = data.analysis3_bodyLocation
        analysis3_date.text = data.analysis3_date
        analysis3_values.text = data.analysis3_values
        analysis4_bodyLocation.text = data.analysis4_bodyLocation
        analysis4_date.text = data.analysis4_date
        analysis4_values.text = data.analysis4_values
        analysis5_bodyLocation.text = data.analysis5_bodyLocation
        analysis5_date.text = data.analysis5_date
        analysis5_values.text = data.analysis5_values

    }

}
