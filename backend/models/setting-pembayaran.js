'use strict';
const {
    Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class SettingPembayaran extends Model {
        static associate(models) {

        }
    };
    SettingPembayaran.init({
        id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        id_angkatan: DataTypes.INTEGER,
        id_jurusan: DataTypes.INTEGER,
        is_karyawan: DataTypes.BOOLEAN,
        biaya_dpp: DataTypes.INTEGER,
        biaya_spp: DataTypes.INTEGER,

    }, {
        sequelize,
        modelName: 'SettingPembayaran',
        tableName: 'setting_pembayaran',
        timestamps: false
    });
    return SettingPembayaran;
};