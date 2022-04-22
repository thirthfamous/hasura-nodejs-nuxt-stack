const { SettingPembayaran, SettingPembayaranOther } = require('./models')
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const salt = 10;

const add = async (request, response) => {
   try{
       // is this data exist ?
       settingPembayaran = await SettingPembayaran.findOne({
           where: {
               id_angkatan: request.body.id_angkatan,
               id_jurusan: request.body.id_prodi,
               is_karyawan: request.body.is_karyawan,
           },
       })
       if (settingPembayaran) {
           console.log(settingPembayaran)
           return response.status(403).json({ message: 'Data sudah pernah dibuat. Silahkan menambahkan dengan data angkatan/prodi/kelas baru' })
       }

       newSettingPembayaran = await SettingPembayaran.create({
           id_angkatan: request.body.id_angkatan,
           id_jurusan: request.body.id_prodi,
           is_karyawan: request.body.is_karyawan,
           biaya_spp: request.body.biaya_spp,
           biaya_dpp: request.body.biaya_dpp
       })
       await newSettingPembayaran.save()
       return response.status(200).json({ settingPembayaran })
   } catch (err) {
       return response.status(500).json({ message: err })
   }
}

const updateOther = async (request, response) => {
    try {
        await request.body.data.forEach(element => {
            SettingPembayaranOther.update(
                { biaya : element.biaya },
                { where: { id: element.id } }
            )});
    } catch (err) {
        console.log(err)
       return response.status(500).json({ message: err })
    }
    return response.status(200).json({ message: 'Berhasil mengupdate data' })
}

module.exports = {
    add, updateOther
}
