const { Sequelize } = require('sequelize');
const { Pool, Client } = require('pg')

const sequelize = new Sequelize('postgres://farhan:101068@postgres:5432/postgres')
const rawDb = new Pool({
    user: 'farhan',
    host: 'postgres',
    database: 'postgres',
    password: '101068',
    port: 5432,
})

module.exports = {
    sequelize,
    rawDb
}