<template>
  <div class="row">
    <div class="col-md-12 bg-white" style="padding: 30px 15px;">
      <h2 class="text-center" style="margin: 10px;">
        PEMBAYARAN MAHASISWA
      </h2>
      <div class="row">
        <div class="col-md-2">
          <img src="zxc" alt="Foto Mahasiswa">
        </div>
        <div class="col-md-10">
          <table class="table">
            <tr>
              <td>Nama</td>
              <td>:</td>
              <td>{{ mahasiswa.nama }}</td>
              <td>Kelas</td>
              <td>:</td>
              <td>{{ (mahasiswa.kelas_mahasiswa !== null) ? mahasiswa.kelas_mahasiswa.kode : 'Belum mempunyai kelas' }} ({{ (mahasiswa.is_karyawan) ? 'Karyawan' : 'Reguler' }})</td>
            </tr>
            <tr>
              <td>NIM</td>
              <td>:</td>
              <td>{{ mahasiswa.nim }}</td>
              <td>Angkatan</td>
              <td>:</td>
              <td>{{ mahasiswa.angkatan.name }}</td>
            </tr>
            <tr>
              <td>Jurusan</td>
              <td>:</td>
              <td>{{ mahasiswa.prodi.nama }}</td>
            </tr>
          </table>
        </div>
      </div>
      <hr>
      <div class="row">
        <div class="col-md-12">
          <a v-b-modal.modal-tambah-transaksi class="btn btn-info pull-right" style="margin-right:30px;">Tambah Transaksi</a>
        </div>
      </div>
      <hr>
      <b-modal id="modal-tambah-transaksi" title="Tambah Transaksi Mahasiswa" hide-footer size="lg">
        <div class="row">
          <div class="col-md-12">
            <table>
              <tr>
                <td>
                  Jenis Pembayaran
                </td>
                <td>
                  :
                </td>
                <td>
                  <select v-model="bayar.id_tipe_pembayaran" class="form-control" @change="fetchBiaya($event)">
                    <option v-for="(data) in tipe_pembayaran" :key="data.id" :value="data.id">
                      {{ data.nama }}
                    </option>
                  </select>
                </td>
              </tr>
              <tr>
                <td>
                  Dibayarkan
                </td>
                <td>:</td>
                <td><input v-model="bayar.jumlah" type="number" class="form-control"></td>
              </tr>
              <tr>
                <td>Catatan</td>
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
      <div class="row">
        <div class="col-md-12">
          <table class="table table-bordered table-sm">
            <thead>
              <tr>
                <th>No</th>
                <th>Nama Pembayaran</th>
                <th>Waktu Pembayaran</th>
                <th>Jumlah Pembayaran</th>
                <th>Aksi</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(data, index) in pembayaran_mahasiwa" :key="data.id">
                <td>{{ index+1 }}</td>
                <td>{{ data.keuangan_tipe_pembayaran.nama }}</td>
                <td><b-form-datepicker :value="data.created_at" /></td>
                <td>Rp. {{ data.jumlah }}</td>
                <td>
                  <a class="btn btn-success" @click="cetakKwitansi(data)">Cetak Kwitansi</a>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <b-modal id="modal-rincian" title="Bayar Rincian Pembayaran" hide-footer size="lg">
          <div class="row">
            <div class="col-md-12">
              <table>
                <tr>
                  <td>
                    Nama Pembayaran
                  </td>
                  <td>
                    :
                  </td>
                  <td>
                    R
                  </td>
                </tr>
                <tr>
                  <td>
                    Sisa Pembayaran
                  </td>
                  <td>:</td>
                  <td>Rp. </td>
                </tr>
                <tr>
                  <td>
                    Dibayarkan
                  </td>
                  <td>:</td>
                  <td><input v-model="bayar.jumlah" type="number" class="form-control"></td>
                </tr>
                <tr>
                  <td>Bisa Pakai Sistem Sampai Tanggal</td>
                  <td>:</td>
                  <td>
                    <b-form-datepicker v-model="bayar.sampai_tanggal" />
                  </td>
                </tr>
                <tr>
                  <td>Catatan</td>
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
      </div>
      <hr>
    </div>
  </div>
</template>

<script>
import Swal from 'sweetalert2'

export default {
  data () {
    return {
      nim: this.$route.params.nim,
      pembayaran_mahasiwa: [],
      bayar: {
        catatan: null,
        jumlah: 0,
        sampai_tanggal: null,
        id_mahasiswa: 0
      },
      tipe_pembayaran: [],
      table_data: [],
      mahasiswa: {
        angkatan: {
          id: 0,
          name: ''
        },
        kelas_mahasiswa: {
          kode: '',
          is_karyawan: false
        },
        prodi: {
          id: 0,
          nama: ''
        },
        biaya: {
          biaya_dpp: 0,
          biaya_spp: 0,
          is_karyawan: false
        },
        nim: '',
        nama: '',
        is_karyawan: false,
        id: 0
      }
    }
  },
  mounted () {
    this.fetchTipePembayaran()
    this.fetchMahasiswa().then(() => {
      this.fetchPembayaran()
    })
  },
  methods: {
    cetakKwitansi () {
      alert('not implemented yet')
    },
    async fetchBiaya (event) {
      const id_tipe_pembayaran = event.target.value
      const id_angkatan = this.mahasiswa.angkatan.id
      const id_jurusan = this.mahasiswa.prodi.id
      const is_karyawan = this.mahasiswa.is_karyawan

      const query = `query getBiaya($id_tipe_pembayaran: Int!, $id_angkatan: Int!, $id_jurusan: uuid!, $is_karyawan: Boolean!) {
                      setting_pembayaran_other(where: {id_tipe_pembayaran: {_eq: $id_tipe_pembayaran}, id_jurusan: {_eq: $id_jurusan}, id_angkatan: {_eq: $id_angkatan}, is_karyawan: {_eq: $is_karyawan}}) {
                        biaya
                        keuangan_tipe_pembayaran {
                          nama
                        }
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
          variables: { id_tipe_pembayaran, id_angkatan, id_jurusan, is_karyawan }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) {
            alert('Error 403 Server Error')
            return
          }
          if (gql.data.setting_pembayaran_other.length === 0) {
            alert('Setting pembayaran ini belum di set, silahkan hubungi administrator')
            this.$bvModal.hide('modal-rincian')
            return
          }
          this.bayar.jumlah = gql.data.setting_pembayaran_other[0].biaya
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    },
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
    async fetchPembayaran () {
      const query = `query getKwitansiOtherMahasiswa($id: Int!) {
  keuangan_pembayaran_mahasiswa_others_kwitansi(where: {id_mahasiswa: {_eq: $id}}) {
    catatan
    jumlah
    keuangan_tipe_pembayaran {
      nama
    }
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
          variables: { id: this.mahasiswa.id }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error'); return }
          this.pembayaran_mahasiwa = gql.data.keuangan_pembayaran_mahasiswa_others_kwitansi
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
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
            id_mahasiswa: this.mahasiswa.id,
            id_tipe_pembayaran: this.bayar.id_tipe_pembayaran
          }
        })
      }).then(res => res.json())
        .then((gql) => {
          if (gql.data) {
            this.$bvModal.hide('modal-rincian')
            this.fetchPembayaran()
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
    async fetchTipePembayaran () {
      const query = `query getTipePembayaran($_in: [Int!] = [1, 2]) {
  keuangan_tipe_pembayaran(where: {type: {_eq: 2}, _and: {_not: {id: {_in: $_in}}}}) {
    id
    nama
    type
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
          query
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error'); return }
          this.tipe_pembayaran = gql.data.keuangan_tipe_pembayaran
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    },
    async fetchMahasiswa () {
      const nim = this.nim
      const query = `query getOneMahasiswa($nim: String!) {
                      mahasiswa(where: {nim: {_eq: $nim}}, limit: 1) {
                        angkatan {
                          id
                          name
                        }
                        kelas_mahasiswa {
                          kode
                        }
                        prodi {
                          id
                          nama
                        }
                        biaya {
                          biaya_dpp
                          biaya_spp
                          is_karyawan
                        }
                        nim
                        nama
                        is_karyawan
                        id
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
          variables: { nim }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error'); return }
          if (gql.data.mahasiswa[0].kelas_mahasiswa === null) {
            alert('Mahasiswa belum ditentukan kelasnya. Silahkan memilih kelas untuk Mahasiswa terlebih dahulu sebelum dapat membuat transaksi keuangan misc')
            this.$router.push({ path: '/keuangan-others' })
            return
          }
          this.mahasiswa = gql.data.mahasiswa[0]
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    }
  }
}
</script>

<style scoped>
  td {
    padding: 10px;
  }
</style>
