'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class UserKaryawan extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      this.hasMany(models.UserKaryawanRole, { foreignKey: 'id', as: 'user_karyawan_role' })
    }
  };
  UserKaryawan.init({
    // Model attributes are defined here
    id: {
      primaryKey: true,
      type: DataTypes.UUID
    },
    name: {
      type: DataTypes.STRING
    },
    username: {
      type: DataTypes.STRING
    },
    email: {
      type: DataTypes.STRING
    },
    password: {
      type: DataTypes.STRING
    }
  }, {
    // Other model options go here
    sequelize, // We need to pass the connection instance
    modelName: 'UserKaryawan', // We need to choose the model name
    tableName: 'user_karyawan',
    timestamps: false
  });
  return UserKaryawan;
};