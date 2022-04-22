<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h2 class="text-center">
        JURNAL TRANSAKSI
      </h2>
      <a style="margin: 7px;" class="btn btn-info pull-right" @click="filter = !filter"><i class="fas fa-filter" />Filter</a>
      <div v-if="filter" class="col-md-5 filter">
        <h5>Filter Tanggal :</h5>
        <form @submit.prevent="processFilter">
          <b-row class="my-1">
            <b-col sm>
              <label>Tanggal Awal :</label>
            </b-col>
            <b-col sm>
              <b-form-datepicker v-model="waktu_awal" size="sm" />
            </b-col>
          </b-row>
          <b-row class="my-1">
            <b-col sm>
              <label>Tanggal Akhir :</label>
            </b-col>
            <b-col sm>
              <b-form-datepicker v-model="waktu_akhir" size="sm" />
            </b-col>
          </b-row>
          <button type="submit" class="btn btn-sm btn-success">
            Process
          </button>
          <button class="btn btn-sm btn-danger" @click="resetFilter">
            Reset
          </button>
        </form>
      </div>
      <table class="table table-bordered table-sm table-sm">
        <thead>
          <tr>
            <th>Kode GL</th>
            <th>
              Nama Perkiraan
            </th>
            <th>
              Debit
            </th>
            <th>
              Kredit
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(data) in data_akuntansi" :key="data.id">
            <td>{{ data.kode }}</td>
            <td>
              {{ data.nama_perkiraan }}
            </td>
            <td>
              {{ formatRupiah(data.debit, 'Rp. ') }}
            </td>
            <td>
              {{ formatRupiah(data.kredit, 'Rp. ') }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
<script>

export default {
  data () {
    return {
      data_akuntansi: [
        {
          kode: '1.03.01',
          nama_perkiraan: 'PIUTANG DPP MAHASISWA',
          debit: 0,
          kredit: 0
        },
        {
          kode: '1.03.02',
          nama_perkiraan: 'PIUTANG SPP MAHASISWA',
          debit: 0,
          kredit: 0
        },
        {
          kode: '1.03.03',
          nama_perkiraan: 'PIUTANG CICILAN MAHASISWA',
          debit: 0,
          kredit: 0
        },
        {
          kode: '2.31.01',
          nama_perkiraan: 'PENDAPATAN DITERIMA DIMUKA DPP',
          debit: 0,
          kredit: 0
        },
        {
          kode: '2.31.02',
          nama_perkiraan: 'PENDAPATAN DITERIMA DIMUKA SPP',
          debit: 0,
          kredit: 0
        },
        {
          kode: '2.31.03',
          nama_perkiraan: 'PENDAPATAN DITERIMA DIMUKA CICILAN',
          debit: 0,
          kredit: 0
        },
        {
          kode: '2.31.04',
          nama_perkiraan: 'PENDAPATAN DITERIMA DIMUKA PENDAFTARAN',
          debit: 0,
          kredit: 0
        }
      ],
      state_awal: [
        {
          kode: '1.03.01',
          nama_perkiraan: 'PIUTANG DPP MAHASISWA',
          debit: 0,
          kredit: 0
        },
        {
          kode: '1.03.02',
          nama_perkiraan: 'PIUTANG SPP MAHASISWA',
          debit: 0,
          kredit: 0
        },
        {
          kode: '1.03.03',
          nama_perkiraan: 'PIUTANG CICILAN MAHASISWA',
          debit: 0,
          kredit: 0
        },
        {
          kode: '2.31.01',
          nama_perkiraan: 'PENDAPATAN DITERIMA DIMUKA SPP',
          debit: 0,
          kredit: 0
        },
        {
          kode: '2.31.02',
          nama_perkiraan: 'PENDAPATAN DITERIMA DIMUKA CICILAN',
          debit: 0,
          kredit: 0
        },
        {
          kode: '2.31.03',
          nama_perkiraan: 'PENDAPATAN DITERIMA DIMUKA PENDAFTARAN',
          debit: 0,
          kredit: 0
        }
      ],
      keuangan: [],
      keuangan_other: [],
      waktu_awal: null,
      waktu_akhir: null,
      filter: false
    }
  },
  created () {
    this.keuangan = []
  },
  methods: {
    resetFilter () {
      this.waktu_awal = null
      this.waktu_akhir = null
      this.processFilter()
    },
    formatRupiah (angka, prefix) {
      const number_string = angka.toString().replace(/[^,\d]/g, '')
      const split = number_string.split(',')
      const sisa = split[0].length % 3
      let rupiah = split[0].substr(0, sisa)
      const ribuan = split[0].substr(sisa).match(/\d{3}/gi)

      // tambahkan titik jika yang di input sudah menjadi angka ribuan
      if (ribuan) {
        const separator = sisa ? '.' : ''
        rupiah += separator + ribuan.join('.')
      }

      rupiah = split[1] !== undefined ? rupiah + ',' + split[1] : rupiah
      return prefix === undefined ? rupiah : (rupiah ? 'Rp. ' + rupiah : '')
    },
    async processFilter () {
      if (this.waktu_awal === null) {
        alert('Harap Mengisi Tanggal Awal Dengan Benar')
      }
      if (this.waktu_akhir === null) {
        alert('Harap Mengisi Tanggal Akhir Dengan Benar')
      }
      await this.fetchMutasi()
      this.processPiutangDpp()
      this.processPiutangSpp()
      this.processPiutangCicilan()
      this.processPendapatanDiterimaDimukaDpp()
      this.processPendapatanDiterimaDimukaSpp()
      this.processPendapatanDiterimaDimukaCicilan()
      this.processPendapatanDiterimaDimukaPendaftaran()
    },
    processPiutangDpp () {
      let debitPiutangDpp = 0
      let kreditPiutangDpp = 0
      this.keuangan.forEach((obj) => {
        if (obj.tipe_rincian === 1) {
          if (obj.is_lunas) {
            kreditPiutangDpp += obj.jumlah_pembayaran
          } else {
            debitPiutangDpp += obj.jumlah_pembayaran
          }
        }
      })

      this.data_akuntansi[0].debit = debitPiutangDpp
      this.data_akuntansi[0].kredit = kreditPiutangDpp
    },
    processPiutangSpp () {
      let debitPiutangSpp = 0
      let kreditPiutangSpp = 0
      this.keuangan.forEach((obj) => {
        if (obj.tipe_rincian === 2) {
          if (obj.is_lunas) {
            kreditPiutangSpp += obj.jumlah_pembayaran
          } else {
            debitPiutangSpp += obj.jumlah_pembayaran
          }
        }
      })

      this.data_akuntansi[1].debit = debitPiutangSpp
      this.data_akuntansi[1].kredit = kreditPiutangSpp
    },
    processPiutangCicilan () {
      let debitPiutangCicilan = 0
      let kreditPiutangCicilan = 0
      this.keuangan.forEach((obj) => {
        if (obj.tipe_rincian === 3) {
          if (obj.is_lunas) {
            kreditPiutangCicilan += obj.jumlah_pembayaran
          } else {
            debitPiutangCicilan += obj.jumlah_pembayaran
          }
        }
      })

      this.data_akuntansi[2].debit = debitPiutangCicilan
      this.data_akuntansi[2].kredit = kreditPiutangCicilan
    },
    processPendapatanDiterimaDimukaDpp () {
      const debitPendapatanDiterimaDimukaDpp = 0
      let kreditPendapatanDiterimaDimukaDpp = 0
      this.keuangan.forEach((obj) => {
        if (obj.tipe_rincian === 1) {
          // uncomment if is_lunas matter
          // if (obj.is_lunas) {
          //   kreditPendapatanDiterimaDimukaDpp += obj.jumlah_pembayaran
          // } else {
          //   debitPendapatanDiterimaDimukaDpp += obj.jumlah_pembayaran
          // }
          kreditPendapatanDiterimaDimukaDpp += obj.jumlah_pembayaran
        }
      })

      this.data_akuntansi[3].debit = debitPendapatanDiterimaDimukaDpp
      this.data_akuntansi[3].kredit = kreditPendapatanDiterimaDimukaDpp
    },
    processPendapatanDiterimaDimukaSpp () {
      const debitPendapatanDiterimaDimukaSpp = 0
      let kreditPendapatanDiterimaDimukaSpp = 0
      this.keuangan.forEach((obj) => {
        if (obj.tipe_rincian === 2) {
          // uncomment if is_lunas matter
          // if (obj.is_lunas) {
          //   kreditPendapatanDiterimaDimukaSpp += obj.jumlah_pembayaran
          // } else {
          //   debitPendapatanDiterimaDimukaSpp += obj.jumlah_pembayaran
          // }
          kreditPendapatanDiterimaDimukaSpp += obj.jumlah_pembayaran
        }
      })

      this.data_akuntansi[4].debit = debitPendapatanDiterimaDimukaSpp
      this.data_akuntansi[4].kredit = kreditPendapatanDiterimaDimukaSpp
    },
    processPendapatanDiterimaDimukaCicilan () {
      const debitPendapatanDiterimaDimukaCicilan = 0
      let kreditPendapatanDiterimaDimukaCicilan = 0
      this.keuangan.forEach((obj) => {
        if (obj.tipe_rincian === 3) {
          // uncomment if is_lunas matter
          // if (obj.is_lunas) {
          //   kreditPendapatanDiterimaDimukaCicilan += obj.jumlah_pembayaran
          // } else {
          //   debitPendapatanDiterimaDimukaCicilan += obj.jumlah_pembayaran
          // }
          kreditPendapatanDiterimaDimukaCicilan += obj.jumlah_pembayaran
        }
      })

      this.data_akuntansi[5].debit = debitPendapatanDiterimaDimukaCicilan
      this.data_akuntansi[5].kredit = kreditPendapatanDiterimaDimukaCicilan
    },
    processPendapatanDiterimaDimukaPendaftaran () {
      const debitPendapatanDiterimaDimukaPendaftaran = 0
      let kreditPendapatanDiterimaDimukaPendaftaran = 0
      this.keuangan_other.forEach((obj) => {
        if (obj.id_tipe_pembayaran === 2) {
          // uncomment if is_lunas matter
          // if (obj.is_lunas) {
          //   kreditPendapatanDiterimaDimukaPendaftaran += obj.jumlah
          // } else {
          //   debitPendapatanDiterimaDimukaPendaftaran += obj.jumlah
          // }
          kreditPendapatanDiterimaDimukaPendaftaran += obj.jumlah
        }
      })

      this.data_akuntansi[6].debit = debitPendapatanDiterimaDimukaPendaftaran
      this.data_akuntansi[6].kredit = kreditPendapatanDiterimaDimukaPendaftaran
    },
    async fetchMutasi () {
      const query = `query getPembayaran($waktu_awal: date!, $waktu_akhir: date!, $waktu_awal_timestamptz: timestamptz!, $waktu_akhir_timestamptz: timestamptz!) {
                      keuangan_pembayaran_mahasiswa_rincian(where: {waktu_pembayaran: {_gte: $waktu_awal, _lte: $waktu_akhir}}, order_by: {id: asc}) {
                        id
                        is_lunas
                        jumlah_pembayaran
                        nama_pembayaran
                        created_at
                        waktu_pembayaran
                        tipe_rincian
                      }
                      keuangan_pembayaran_mahasiswa_others_kwitansi(where: {created_at: {_gte: $waktu_awal_timestamptz, _lte: $waktu_akhir_timestamptz}}, order_by: {id: asc}) {
                        id
                        id_tipe_pembayaran
                        jumlah
                        created_at
                      }
                    }
                    `
      const waktu_awal = (this.waktu_awal) ? this.waktu_awal : null
      const waktu_akhir = (this.waktu_akhir) ? this.waktu_akhir : null
      const waktu_awal_timestamptz = (this.waktu_awal) ? this.$moment(this.waktu_awal).format('YYYY-MM-DD HH:mm:ss') : null
      const waktu_akhir_timestamptz = (this.waktu_akhir) ? this.$moment(this.waktu_akhir).format('YYYY-MM-DD HH:mm:ss') : null

      await fetch(process.env.gql, {
        method: 'post',
        headers: {
          Authorization: `Bearer ${this.$cookies.get('token')}`,
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'x-hasura-role': this.$cookies.get('role')
        },
        body: JSON.stringify({
          query,
          // eslint-disable-next-line camelcase
          variables: { waktu_awal, waktu_akhir, waktu_awal_timestamptz, waktu_akhir_timestamptz }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.keuangan = gql.data.keuangan_pembayaran_mahasiswa_rincian
          this.keuangan_other = gql.data.keuangan_pembayaran_mahasiswa_others_kwitansi
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    }
  }
}
</script>
<style scoped>
  .bg-white {
    padding: 20px;
  }

  .filter {
    background-color:#e4e6d7; padding: 20px 10px;
    margin-bottom: 20px;
  }

  td {
    white-space:nowrap;
    padding-left: 15px;
  }

  th {
      padding-left: 15px;
  }
</style>
