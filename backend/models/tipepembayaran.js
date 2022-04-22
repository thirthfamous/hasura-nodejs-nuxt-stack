'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class TipePembayaran extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  };
  TipePembayaran.init({
    nama: DataTypes.STRING,
    created_at: DataTypes.TIME,
    updated_at: DataTypes.TIME,
    type: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'TipePembayaran',
    tableName: 'keuangan_tipe_pembayaran',
    timestamps: false
  });
  return TipePembayaran;
};