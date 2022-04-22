const { KeuanganBalance, 
    KeuanganTransaksi, TipePembayaran } = require('./models')


const updateBalance = async (jumlah, operasi) => {
    // get balance nya
    let balance = await KeuanganBalance.findOne()
    
    balance = balance.balance

    

    if(operasi === 1){ // tambah
        // tambah balance nya / debit
        balance = balance + jumlah
    }else {// ngurang
        // ngurang balance nya / kredit
        balance = balance - jumlah
    }
    
    // update value balance nya
    await KeuanganBalance.update({ balance: balance }, {
        where: {
            id: 1
        }
    })
    return balance;
}

const insertTransaksiKeuangan = async (jumlah, nama_pembayaran, balance_now, created_by, id_tipe_pembayaran) => {
    await KeuanganTransaksi.create({
        jumlah: jumlah,
        nama_pembayaran: nama_pembayaran, 
        balance_now: balance_now,
        created_by: created_by,
        created_at: new Date(),
        id_tipe_pembayaran: id_tipe_pembayaran
    })
}

const getTipePembayaran = async (id) => {
    return await TipePembayaran.findOne({
        where: {
            id: id
        }
    })
}

module.exports = {
    updateBalance,
    insertTransaksiKeuangan,
    getTipePembayaran
}
