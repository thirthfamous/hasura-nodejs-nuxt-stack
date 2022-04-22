<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h2 class="text-center">
        Entry Jurnal
      </h2>
      <NuxtLink to="/jurnal/tambah" class="btn btn-success pull-right" style="margin: 7px">
        <i class="fas fa-plus-square" /> Tambah Jurnal
      </NuxtLink>
      <a style="margin: 7px;" class="btn btn-info pull-right" @click="filter = !filter"><i class="fas fa-filter" />Filter</a>
      <div v-if="filter" class="col-md-6 filter">
        <h5>Filter :</h5>
          <b-row class="form-group">
            <b-col sm="3">
              <label>Tipe Akun :</label>
            </b-col>
            <b-col sm="7">
              <b-form-select v-model="id_tipe_filter" size="sm">
                <b-form-select-option key="0" selected value="0">
                  Semua
                </b-form-select-option>
                <b-form-select-option v-for="data in akuntansi_master_tipe" :key="data.id" :value="data.id">
                  {{ data.nama }}
                </b-form-select-option>
              </b-form-select>
            </b-col>
          </b-row>
      </div>
      <table class="table table-bordered table-sm table-sm">
        <thead>
          <tr>
            <th>
              Tanggal
            </th>
            <th>
              Akun
            </th>
            <th>
              Keterangan
            </th>
            <th>
              Referensi
            </th>
            <th>
              Debit
            </th>
            <th>
              Kredit
            </th>
            <th class="text-center center">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(data) in akuntansi_jurnal" :key="data.id">
              <td>
                {{ $moment(data.tanggal).format('DD-MM-YYYY') }}
              </td>
              <td>
               {{ data.kode_akun }} - {{ data.akuntansi_master_akun.nama }}
              </td>
              <td>
                {{ data.keterangan }}
              </td>
              <td>
                {{ data.ref }}
              </td>
              <td>
                {{ formatRupiah(data.debit, 'Rp. ') }}
              </td>
              <td>
                {{ formatRupiah(data.kredit, 'Rp. ') }}
              </td>
              <td class="text-center center">
                <a class="btn btn-primary" @click="editJurnal(data.id)"> Edit  </a>
                <a class="btn btn-danger" @click="hapusJurnal(data.id)"> Hapus </a>
                </td>
          </tr>
        </tbody>
      </table>
      <b-pagination
        v-model="page"
        class="pull-right"
        :total-rows="total_row"
        :per-page="limit"
        prev-text="Prev"
        next-text="Next"
        @change="handlePageChange"
      />
    </div>
  </div>
</template>
<script>
import Swal from 'sweetalert2'

export default {
  data () {
    return {
      akuntansi_jurnal: [],
      limit: 20,
      offset: 0,
      total_row: 0,
      page: 1,
      filter: false
    }
  },
  mounted () {
    this.fetchData()
  },
  methods: {
    editJurnal (id_jurnal) {
      this.$router.push({ path: `/jurnal/edit/${id_jurnal}` })
    },
    hapusJurnal (id_jurnal) {
      const query = `mutation DeleteJurnal($id: Int!) {
                      delete_akuntansi_jurnal_by_pk(id: $id) {
                        tanggal
                        ref
                        kredit
                        kode_akun
                        keterangan
                        id
                        debit
                        created_by
                        created_at
                        updated_at
                      }
                    }
                    `
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
          variables: { id: id_jurnal }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.data) {
            Swal.fire({
              icon: 'success',
              title: 'Jurnal Berhasil Hapus',
              showConfirmButton: false
            })
            this.fetchData()
            return true
          }
          Swal.fire({
            icon: 'error',
            title: 'Server Error',
            text: 'Terjadi kesalahan pada Server',
            showConfirmButton: false
          })
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    },
    handlePageChange (value) {
      this.page = value
      this.offset = (this.page - 1) * this.limit
      this.fetchData()
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
    fetchData () {
      const query = `query GetJurnalAkuntansi($limit: Int!, $offset: Int!) {
                      akuntansi_jurnal(limit: $limit, offset: $offset, order_by: {created_at: asc}) {
                        id
                        keterangan
                        kode_akun
                        ref
                        tanggal
                        debit
                        kredit
                        created_by
                        akuntansi_master_akun {
                          nama
                        }
                      }
                    }
                    `
      const limit = this.limit
      const offset = this.offset
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
          variables: { limit, offset }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.akuntansi_jurnal = gql.data.akuntansi_jurnal
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

  .center {
    padding-left: 0px;
  }

  td {
    white-space:nowrap;
    padding-left: 15px;
  }

  th {
      padding-left: 15px;
  }
</style>
