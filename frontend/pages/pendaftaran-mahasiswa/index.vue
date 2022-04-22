<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h2 class="text-center">
        PEMBAYARAN PENDAFTARAN MAHASISWA
      </h2>
      <a style="margin: 7px;" class="btn btn-info pull-right" @click="filter = !filter"><i class="fas fa-filter" />Filter</a>
      <div v-if="filter" class="col-md-5 filter">
        <h5>Filter Mahasiswa :</h5>
        <form @submit.prevent="processFilter">
          <b-row class="my-1">
            <b-col sm>
              <label>Kode Pendaftaran :</label>
            </b-col>
            <b-col sm>
              <b-form-input v-model="kode_pendaftaran" size="sm" type="text" />
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
          <tr class="text-center">
            <th>No</th>
            <th>
              Nama
            </th>
            <th>
              Kode Pendaftaran
            </th>
            <th>
              Status Pembayaran
            </th>
            <th>Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(data, index) in mahasiswa" :key="data.id" class="text-center">
            <td>{{ (page == 1) ? index + 1 : (page * 10) + index - limit + 1 }}</td>
            <td>
              {{ data.nama }}
            </td>
            <td>
              {{ data.kode_pendaftaran }}
            </td>
            <td>
              <div v-if="mahasiswa.length != 0">
                {{ (data.keuangan_pembayaran_mahasiswa_others_kwitansis[0] === undefined ) ? 'Belum bayar' : 'Sudah Bayar' }}
              </div>
            </td>
            <td>
              <a v-if="data.keuangan_pembayaran_mahasiswa_others_kwitansis[0] === undefined " class="btn btn-info" v-b-modal.modal-bayar-pendaftaran>
                Bayar
              </a>
              <a v-else class="btn btn-success" @click="cetakKwitansi(data.keuangan_pembayaran_mahasiswa_others_kwitansis[0].id)">
                Cetak Kwitansi
              </a>
            </td>
          </tr>
        </tbody>
      </table>
      <b-modal id="modal-bayar-pendaftaran" title="Bayar Pendaftaran Mahasiswa" hide-footer size="lg">
        <div class="row">
          <div class="col-md-12">
            <table class="table">
              <tr>
                <td>
                  Dibayarkan
                </td>
                <td>:</td>
                <td><input v-model="bayar.jumlah" type="number" class="form-control"></td>
              </tr>
              <tr>
                <td>Catatan Tambahan</td>
                <td>:</td>
                <td><textarea v-model="bayar.catatan" class="form-control" cols="10" rows="5" /></td>
              </tr>
            </table>
            <div>
              <small class="text-danger">Harap untuk berhati-hati ketika mengklik tombol Bayar. Karena transaksi yang dibuat akan menjadi lunas dan tidak bisa di REVERT.
                Pastikan untuk mengecek kembali data yang di input. </small>
            </div>
            <div style="margin: 10px 0px;">
              <a class="btn btn-success" @click="showConfirmModalPembayaran">Bayar</a>
            </div>
          </div>
        </div>
      </b-modal>
      <b-pagination
        v-model="page"
        class="pull-right"
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
      mahasiswa: [
        {
          id: 0,
          nama: '',
          email: '',
          nim: '',
          angkatan: {
            nama: ''
          },
          prodi: {
            id: '',
            nama: ''
          }
        }
      ],
      bayar: {
        jumlah: 0,
        catatan: ''
      },
      limit: 10,
      offset: 0,
      kode_pendaftaran: null,
      id_prodi: null,
      id_angkatan: null,
      page: 1,
      filter: false
    }
  },
  created () {
    this.mahasiswa = []
  },
  methods: {
    showConfirmModalPembayaran () {
      this.$bvModal.msgBoxConfirm('Tolong Pastikan Semua Data Di Input Dengan Tepat. Data Yang Sudah Di Input Tidak Bisa Di Revert', {
        title: 'Apakah Anda Yakin Ingin Melunasi Tagihan Ini ?',
        size: 'sm',
        buttonSize: 'sm',
        okVariant: 'primary',
        okTitle: 'YES',
        cancelTitle: 'NO',
        footerClass: 'p-2',
        hideHeaderClose: false,
        centered: true
      })
        .then((value) => {
          if (value) {
            this.submitKwitansi()
          }
        })
        .catch((err) => {
          console.error('There was an error!', err)
        })
    },
    async submitKwitansi () {
      // insert ke pembayaran kwitansi dan rubah jadi lunas di rincian
      const query = `mutation insertKwitansiOtherMahasiswa($catatan: String!, $id_mahasiswa: Int!, $id_tipe_pembayaran: Int!, $jumlah: Int!) {
                    insert_keuangan_pembayaran_mahasiswa_others_kwitansi_one(object: {id_mahasiswa: $id_mahasiswa, id_tipe_pembayaran: $id_tipe_pembayaran, jumlah: $jumlah, catatan: $catatan}) {
                        jumlah
                        id_tipe_pembayaran
                        id_mahasiswa
                        id
                        created_by
                        catatan
                        created_at
                    }
                    }
`
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
          variables: {
            catatan: this.bayar.catatan,
            jumlah: this.bayar.jumlah,
            id_mahasiswa: this.mahasiswa[0].id,
            id_tipe_pembayaran: 2
          }
        })
      }).then(res => res.json())
        .then((gql) => {
          if (gql.data) {
            this.$bvModal.hide('modal-bayar-pendaftaran')
            this.mahasiswa = []
            Swal.fire({
              icon: 'success',
              title: 'Pembayaran Berhasil Dibayarkan',
              showConfirmButton: false
            })
            return true
          }
          if (gql.errors[0].extensions.code === 'validation-failed') {
            Swal.fire({
              icon: 'error',
              title: 'Server Error',
              text: 'Terjadi kesalahan! Harap mengisi form dengan benar',
              showConfirmButton: false
            })
            return false
          }
          Swal.fire({
            icon: 'error',
            title: 'Server Error',
            text: 'Terjadi kesalahan pada server!',
            showConfirmButton: false
          })
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    },
    resetFilter () {
      this.nim = null
      this.processFilter()
    },
    handlePageChange (value) {
      this.page = value
      this.offset = (this.page - 1) * this.limit
      this.fetchMahasiswa()
    },
    processFilter () {
      this.offset = 0
      this.fetchMahasiswa()
    },
    fetchMahasiswa () {
      const query = `query getMahasiswa($limit: Int!, $offset: Int!, $kode_pendaftaran: String, $id_prodi: uuid, $id_angkatan: Int) {
  mahasiswa(limit: $limit, offset: $offset, order_by: {id: desc}, where: {kode_pendaftaran: {_eq: $kode_pendaftaran}, prodi: {id: {_eq: $id_prodi}}, angkatan: {id: {_eq: $id_angkatan}}}) {
    id
    nama
    email
    kode_pendaftaran
    angkatan {
      name
    }
    prodi {
      nama
      id
    }
    keuangan_pembayaran_mahasiswa_others_kwitansis(where: {id_tipe_pembayaran: {_eq: 2}}) {
      id
      id_mahasiswa
      catatan
      jumlah
    }
  }
}
`
      const limit = this.limit
      const offset = this.offset
      // eslint-disable-next-line camelcase
      const kode_pendaftaran = (this.kode_pendaftaran) ? this.kode_pendaftaran : null
      // eslint-disable-next-line camelcase
      const id_prodi = (this.id_prodi) ? this.id_prodi : null
      // eslint-disable-next-line camelcase
      const id_angkatan = (this.id_angkatan) ? this.id_angkatan : null

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
          variables: { limit, offset, kode_pendaftaran, id_prodi, id_angkatan }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.mahasiswa = gql.data.mahasiswa
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
</style>
