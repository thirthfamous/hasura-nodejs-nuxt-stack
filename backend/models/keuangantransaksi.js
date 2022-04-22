'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class KeuanganTransaksi extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  };
  KeuanganTransaksi.init({
    id_tipe_pembayaran: DataTypes.INTEGER,
    nama_pembayaran: DataTypes.STRING,
    jumlah: DataTypes.INTEGER,
    balance_now: DataTypes.INTEGER,
    created_by: DataTypes.UUID,
    created_at: DataTypes.TIME
  }, {
    sequelize,
    modelName: 'KeuanganTransaksi',
    tableName: 'keuangan_transaksi',
    timestamps: false
  });
  return KeuanganTransaksi;
};