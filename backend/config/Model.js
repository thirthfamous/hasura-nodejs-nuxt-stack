// const { Sequelize, DataTypes, Model } = require('sequelize');
// const { sequelize } = require('../connection');
// // const Role = require('./Role');
// // const UserKaryawan = require('./UserKaryawan');

// class UserKaryawanRole extends Model { }
// class Role extends Model { }
// class UserKaryawan extends Model { }
// class Navigation extends Model { }
// class RoleNavigation extends Model { }

// UserKaryawan.init({
//   // Model attributes are defined here
//   id: {
//     primaryKey: true,
//     type: DataTypes.UUID
//   },
//   name: {
//     type: DataTypes.STRING
//   },
//   username: {
//     type: DataTypes.STRING
//   },
//   email: {
//     type: DataTypes.STRING
//   },
//   password: {
//     type: DataTypes.STRING
//   }
// }, {
//   // Other model options go here
//   sequelize, // We need to pass the connection instance
//   modelName: 'UserKaryawan', // We need to choose the model name
//   tableName: 'user_karyawan',
//   timestamps: false
// });

// Role.init({
//   // Model attributes are defined here
//   id: {
//     primaryKey: true,
//     type: DataTypes.INTEGER
//   },
//   name: {
//     type: DataTypes.STRING
//   }
// }, {
//   // Other model options go here
//   sequelize, // We need to pass the connection instance
//   modelName: 'Role', // We need to choose the model name
//   tableName: 'role',
//   timestamps: false
// });

// UserKaryawanRole.init({
//   // Model attributes are defined here
//   id: {
//     primaryKey: true,
//     type: DataTypes.UUID
//   },
//   id_role: {
//     type: DataTypes.INTEGER,
//     references: {
//       model: Role,
//       key: 'id'
//     }
//   },
//   id_user_karyawan: {
//     type: DataTypes.UUID,
//     references: {
//       model: UserKaryawan,
//       key: 'id'
//     }
//   }
// }, {
//   // Other model options go here
//   sequelize, // We need to pass the connection instance
//   modelName: 'UserKaryawanRole', // We need to choose the model name
//   tableName: 'user_karyawan_role',
//   timestamps: false
// });

// Navigation.init({
//   // Model attributes are defined here
//   id: {
//     primaryKey: true,
//     type: DataTypes.INTEGER
//   },
//   nama: {
//     type: DataTypes.TEXT,
//   },
//   icon: {
//     type: DataTypes.TEXT,
//   },
//   link: {
//     type: DataTypes.TEXT,
//   },
//   id_parent: {
//     type: DataTypes.INTEGER,
//   }
// }, {
//   // Other model options go here
//   sequelize, // We need to pass the connection instance
//   modelName: 'Navigation', // We need to choose the model name
//   tableName: 'navigation',
//   timestamps: false
// });

// RoleNavigation.init({
//   // Model attributes are defined here
//   id: {
//     primaryKey: true,
//     type: DataTypes.INTEGER
//   },
//   id_role: {
//     type: DataTypes.INTEGER,
//     references: {
//       model: Role,
//       key: 'id'
//     }
//   },
//   id_navigation: {
//     type: DataTypes.INTEGER,
//     references: {
//       model: Navigation,
//       key: 'id'
//     }
//   }
// }, {
//   // Other model options go here
//   sequelize, // We need to pass the connection instance
//   modelName: 'RoleNavigation', // We need to choose the model name
//   tableName: 'role_navigation',
//   timestamps: false
// });

// UserKaryawanRole.belongsTo(UserKaryawan, { as: 'UserKaryawan', foreignKey: 'id' });
// UserKaryawanRole.belongsTo(Role, { as: 'Role', foreignKey: 'id' });
// Role.hasMany(UserKaryawanRole, { as: 'UserKaryawanRole', foreignKey: 'id_role' })
// Role.hasMany(UserKaryawanRole, { as: 'UserKaryawanRole', foreignKey: 'id_role' })
// UserKaryawan.hasMany(UserKaryawanRole, { as: 'UserKaryawanRole', foreignKey: 'id_user_karyawan' });
// Role.hasMany(RoleNavigation, { as: 'RoleNavigation', foreignKey: 'id_role' })
// Navigation.hasMany(RoleNavigation, { as: 'RoleNavigation', foreignKey: 'id_navigation' })
// RoleNavigation.belongsTo(Role, { as: 'Role', foreignKey: 'id' });
// RoleNavigation.belongsTo(Navigation, { as: 'Navigation', foreignKey: 'id' });


// module.exports = {
//   UserKaryawanRole: UserKaryawanRole,
//   UserKaryawan: UserKaryawan,
//   Role: Role,
//   Navigation: Navigation,
//   RoleNavigation: RoleNavigation
// }