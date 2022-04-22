'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class UserKaryawanRole extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate({ Role }) {
      this.belongsTo(Role, {foreignKey: 'id_role', as:'role'})
    }
  };
  UserKaryawanRole.init({
    // Model attributes are defined here
    id: {
      primaryKey: true,
      type: DataTypes.UUID
    },
    id_role: {
      type: DataTypes.INTEGER,
    },
    id_user_karyawan: {
      type: DataTypes.UUID,
    }
  }, {
    // Other model options go here
    sequelize, // We need to pass the connection instance
    modelName: 'UserKaryawanRole', // We need to choose the model name
    tableName: 'user_karyawan_role',
    timestamps: false
  });
  return UserKaryawanRole;
};