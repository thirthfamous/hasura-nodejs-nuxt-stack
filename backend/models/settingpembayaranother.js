'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class SettingPembayaranOther extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  };
  SettingPembayaranOther.init({
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    id_angkatan: DataTypes.INTEGER,
    id_jurusan: DataTypes.UUID,
    is_karyawan: DataTypes.BOOLEAN,
    id_tipe_pembayaran: DataTypes.INTEGER,
    updated_at: DataTypes.TIME,
    updated_by: DataTypes.UUID,
    biaya: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'SettingPembayaranOther',
    tableName: 'setting_pembayaran_other',
    timestamps: false
  });
  return SettingPembayaranOther;
};