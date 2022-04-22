'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class KeuanganBalance extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  };
  KeuanganBalance.init({
    balance: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'KeuanganBalance',
    tableName: 'keuangan_balance',
    timestamps: false
  });
  return KeuanganBalance;
};