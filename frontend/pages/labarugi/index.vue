<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h2 class="text-center">
        Laporan Laba Rugi
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
            <th>Kode Akun</th>
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
          <tr v-for="(data) in keuangan" :key="data.kode">
            <td>{{ data.kode }}</td>
            <td>
              {{ data.nama }}
            </td>
            <td>
              <p v-if="data.akuntansi_jurnals.length !== 0">
                {{ formatRupiah(hitungTotal(data.akuntansi_jurnals, 1), 'Rp. ') }}
              </p>
              <p v-else>
                Rp. 0
              </p>
            </td>
            <td>
              <p v-if="data.akuntansi_jurnals.length !== 0">
                {{ formatRupiah(hitungTotal(data.akuntansi_jurnals, 2), 'Rp. ') }}
              </p>
              <p v-else>
                Rp. 0
              </p>
            </td>
          </tr>
          <tr>
            <td>.</td>
            <td>
              <p style="text-align: right; padding-right: 10px;">
                Total :
              </p>
            </td>
            <td style="font-weight: bold">
              {{ formatRupiah(debit_total, 'Rp. ') }}
            </td>
            <td style="font-weight: bold">
              {{ formatRupiah(kredit_total, 'Rp. ') }}
            </td>
          </tr>
          <tr>
            <td>.</td>
            <td>
              <p style="text-align: right; padding-right: 10px;">
                Laba/Rugi :
              </p>
            </td>
            <td style="font-weight: bold" colspan="2">
              <p v-if="debit_total - kredit_total <= 0" class="text-danger">
                {{ formatRupiah(debit_total - kredit_total, 'Rp. -') }}
              </p>
              <p v-else class="text-success">
                {{ formatRupiah(debit_total - kredit_total, 'Rp. +') }}
              </p>
            </td>
            <!-- <td style="font-weight: bold">
              {{ formatRupiah(kredit_total, 'Rp. ') }}
            </td> -->
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
      keuangan: [],
      waktu_awal: null,
      waktu_akhir: null,
      filter: false,
      debit_total: 0,
      kredit_total: 0,
      inc: 0
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
    hitungTotal (data, saldo) {
      let total = 0
      if (saldo === 1) {
        data.forEach((element) => {
          total = total + element.debit
        })
        if (total === 0) {
          return total
        }
      }
      if (saldo === 2) {
        data.forEach((element) => {
          total = total + element.kredit
        })
        if (total === 0) {
          return total
        }
      }
      return total
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
      return prefix === undefined ? rupiah : (rupiah ? prefix + rupiah : '')
    },
    async processFilter () {
      if (this.waktu_awal === null) {
        alert('Harap Mengisi Tanggal Awal Dengan Benar')
        return
      }
      if (this.waktu_akhir === null) {
        alert('Harap Mengisi Tanggal Akhir Dengan Benar')
        return
      }
      this.debit_total = 0
      this.kredit_total = 0
      await this.fetchMutasi()
      this.processTotal()
    },
    processTotal () {
      let total_debit = 0
      let total_kredit = 0
      this.keuangan.forEach((akun) => {
        if (akun.akuntansi_jurnals.length !== 0) {
          akun.akuntansi_jurnals.forEach((jurnal) => {
            if (jurnal.debit !== 0) {
              total_debit = total_debit + jurnal.debit
            }
            if (jurnal.kredit !== 0) {
              total_kredit = total_kredit + jurnal.kredit
            }
          })
        }
      })
      this.debit_total = total_debit
      this.kredit_total = total_kredit
    },
    async fetchMutasi () {
      const query = `query getNeraca($waktu_awal: date!, $waktu_akhir: date!) {
                      akuntansi_master_akun(where: {akuntansi_master_tipe: {akuntansi_master_kategori: {id: {_in: [4,5]}}}}) {
                        akuntansi_jurnals(where: {tanggal: {_gte: $waktu_awal, _lte: $waktu_akhir}}) {
                          kode_akun
                          keterangan
                          debit
                          kredit
                        }
                        saldo_normal
                        nama
                        kode
                      }
                    }
                    `
      const waktu_awal = (this.waktu_awal) ? this.waktu_awal : null
      const waktu_akhir = (this.waktu_akhir) ? this.waktu_akhir : null

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
          variables: { waktu_awal, waktu_akhir }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.keuangan = gql.data.akuntansi_master_akun
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
  .total {
    padding-right: 15px;
  }
</style>
