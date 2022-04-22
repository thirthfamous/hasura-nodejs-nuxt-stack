'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Role extends Model {
    
    static associate(models) {
      this.hasMany(models.UserKaryawanRole, { foreignKey:'id_role', as: 'user_karyawan_role' })
    }
  };
  Role.init({
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true      
    },
    name: DataTypes.TEXT,
    role_name: DataTypes.TEXT
  }, {
    sequelize,
    modelName: 'Role',
    tableName: 'role',
    timestamps: false
  });
  return Role;
};