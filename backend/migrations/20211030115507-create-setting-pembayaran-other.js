'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('SettingPembayaranOthers', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      id_angkatan: {
        type: Sequelize.INTEGER
      },
      id_jurusan: {
        type: Sequelize.UUID
      },
      is_karyawan: {
        type: Sequelize.BOOLEAN
      },
      id_tipe_pembayaran: {
        type: Sequelize.INTEGER
      },
      created_at: {
        type: Sequelize.TIME
      },
      created_by: {
        type: Sequelize.UUID
      },
      biaya: {
        type: Sequelize.INTEGER
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable('SettingPembayaranOthers');
  }
};