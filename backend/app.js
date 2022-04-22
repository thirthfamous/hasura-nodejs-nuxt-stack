const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const db = require('./auth');
const sb = require('./setting-pembayaran');
const { updateBalance, insertTransaksiKeuangan, getTipePembayaran } = require('./keuangan');


app.use(bodyParser.json());

app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
  res.setHeader("Access-Control-Allow-Credentials", "true");
  res.setHeader("Access-Control-Allow-Headers", "content-type");
  next();
});


app.post('/login', async (req, res) => {
  db.login(req,res)
});

app.post('/signup', async (req, res) => {
  return res.json('yo');
});

app.post('/sppdpp-update-balance', async (req, res) => {

  try{
    // get request input
    const jumlah = req.body.event.data.new.jumlah
    const id_kwitansi = req.body.event.data.new.id
    const operasi = 1 // debit

    const balanceNow = await updateBalance(jumlah, operasi)
    const nama = `Pembayaran SPP/DPP sejumlah ${jumlah}. ID Kwitansi SPP/DPP : ${id_kwitansi}. Debit`
    const created_by = req.body.event.session_variables['x-hasura-user-id']
    const id_tipe_pembayaran = 1 // debit SPP/DPP

    await insertTransaksiKeuangan(jumlah, nama, balanceNow, created_by, id_tipe_pembayaran).then( () => {
      console.log('Insert Transaksi Keuangan Berhasil')
    })
  } catch (e){
    console.error(e)
    return res.status(400).json({
      message: "Server Error"
    })
  }
  // success
  return res.json({
    status : 200
  })
});

app.post('/other-update-balance', async (req, res) => {
  try {
    const data = req.body.event.data
    const jumlah = data.new.jumlah
    const id_kwitansi = data.new.id
    const operasi = 1 // debit
    const id_tipe_pembayaran = data.new.id_tipe_pembayaran
    let nama = null
    const created_by = req.body.event.session_variables['x-hasura-user-id']

    const balanceNow = await updateBalance(jumlah, operasi)
    const tipe_pembayaran = await getTipePembayaran(id_tipe_pembayaran).then( (data) => {
      nama = `Pembayaran ${data.nama} sejumlah ${jumlah}. ID Kwitansi : ${id_kwitansi}. Debit`
    })

    await insertTransaksiKeuangan(jumlah, nama, balanceNow, created_by, id_tipe_pembayaran).then(() => {
      console.log('Insert Transaksi Keuangan Berhasil')
    })

  } catch (e) {
    console.error(e)
    return res.status(400).json({
      message: "Server Error"
    })
  }

  // success
  return res.json({
    status: 200
  })
})

app.post('/setting-pembayaran/create', async (req, res) => {
  sb.add(req, res)
});

console.log('CONNECTED TO BACKEND');
app.listen(80);
