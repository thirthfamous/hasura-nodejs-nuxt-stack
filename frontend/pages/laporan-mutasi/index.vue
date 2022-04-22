<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h2 class="text-center">
        LAPORAN MUTASI
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
      <div class="table-responsive" style="font-size:14px">
        <table class="table table-bordered table-sm">
        <thead>
          <tr class="text-center">
            <th>No</th>
            <th>
              Tanggal
            </th>
            <th>
              Pembayaran
            </th>
            <th style="width: 5%">
              Uraian
            </th>
            <th>
              Tipe
            </th>
            <th>
              Nominal
            </th>
            <th>
              Saldo Akhir
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(data, index) in keuangan_transaksi" :key="data.id" class="text-center">
            <td>{{ (page == 1) ? index + 1 : (page * 10) + index - limit + 1 }}</td>
            <td>
              {{ $moment(data.created_at).format('DD-MM-YYYY') }}
            </td>
            <td>
              {{ data.keuangan_tipe_pembayaran.nama }}
            </td>
            <td>
              {{ data.nama_pembayaran }}
            </td>
            <td>
              {{ (data.keuangan_tipe_pembayaran.type === 2) ? 'Debit' : 'Kredit' }}
            </td>
            <td>
              {{ formatRupiah(data.jumlah, 'Rp. ') }}
            </td>
            <td>
              {{ formatRupiah(data.balance_now, 'Rp. ') }}
            </td>
          </tr>
        </tbody>
      </table>
      </div>
      <b-pagination
        v-model="page"
        class="pull-right"
        :per-page="limit"
        :total-rows="total_row"
        prev-text="Prev"
        next-text="Next"
        @change="handlePageChange"
      />
    </div>
  </div>
</template>
<script>

export default {
  data () {
    return {
      keuangan_transaksi: [
        {
          id: 0,
          balance_now: 0,
          id_tipe_pembayaran: 0,
          jumlah: 0,
          nama_pembayaran: '',
          keuangan_tipe_pembayaran: {
            nama: '',
            type: 0
          },
          created_at: null
        }
      ],
      waktu_awal: null,
      waktu_akhir: null,
      limit: 10,
      offset: 0,
      total_row: 0,
      page: 1,
      filter: false
    }
  },
  created () {
    this.keuangan_transaksi = []
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
    handlePageChange (value) {
      this.page = value
      this.offset = (this.page - 1) * this.limit
      this.fetchMutasi()
    },
    processFilter () {
      if (this.waktu_awal === null) {
        alert('Harap Mengisi Tanggal Awal Dengan Benar')
      }
      if (this.waktu_akhir === null) {
        alert('Harap Mengisi Tanggal Akhir Dengan Benar')
      }
      this.offset = 0
      this.fetchMutasi()
    },
    fetchMutasi () {
      const query = `query getMutasiBank($limit: Int!, $offset: Int!, $waktu_awal: timestamptz!, $waktu_akhir: timestamptz!) {
                      keuangan_transaksi(limit: $limit, offset: $offset, where: {created_at: {_gte: $waktu_awal, _lte: $waktu_akhir}}, order_by: {id: desc}) {
                        balance_now
                        id_tipe_pembayaran
                        jumlah
                        nama_pembayaran
                        keuangan_tipe_pembayaran {
                          nama
                          type
                        }
                        created_at
                        id
                      }
                      keuangan_transaksi_aggregate(where: {created_at: {_gte: $waktu_awal, _lte: $waktu_akhir}}) {
                        aggregate {
                          count
                        }
                      }
                    }
                    `
      const limit = this.limit
      const offset = this.offset
      const waktu_awal = (this.waktu_awal) ? this.waktu_awal : null
      const waktu_akhir = (this.waktu_akhir) ? this.waktu_akhir : null

      fetch(process.env.gql, {
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
          variables: { waktu_awal, waktu_akhir, limit, offset }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.keuangan_transaksi = gql.data.keuangan_transaksi
          this.total_row = gql.data.keuangan_transaksi_aggregate.aggregate.count
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
  }

  td {
    white-space:nowrap;
  }
</style>
