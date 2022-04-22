<template>
  <div class="row">
    <div class="col-md-12 bg-white" style="padding: 30px 15px;">
      <h2 class="text-center" style="margin: 10px;">
        DETAIL SPP DPP MAHASISWA
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
              <td>
                {{ (mahasiswa.kelas_mahasiswa !== null) ? mahasiswa.kelas_mahasiswa.kode : 'Belum ada' }}
                ({{ (mahasiswa.is_karyawan !== null) ? (mahasiswa.is_karyawan) ? 'Karyawan' : 'Reguler' : 'Belum ada' }})
              </td>
            </tr>
            <tr>
              <td>NIM</td>
              <td>:</td>
              <td>{{ mahasiswa.nim }}</td>
              <td>Angkatan</td>
              <td>:</td>
              <td>{{ (mahasiswa.angkatan !== null) ? mahasiswa.angkatan.name : 'Angkatan belum ditentukan' }}</td>
            </tr>
            <tr>
              <td>Jurusan</td>
              <td>:</td>
              <td>{{ (mahasiswa.prodi !== null) ? mahasiswa.prodi.nama : 'Prodi belum ditentukan' }}</td>
            </tr>
            <tr>
              <td>Biaya SPP</td>
              <td>:</td>
              <td>Rp. {{ mahasiswa.biaya.biaya_spp }} </td>
            </tr>
            <tr>
              <td>Biaya DPP</td>
              <td>:</td>
              <td>Rp. {{ mahasiswa.biaya.biaya_dpp }}</td>
            </tr>
          </table>
        </div>
      </div>
      <hr>
      <div class="row">
        <div v-if="pembayaran_mahasiwa.length == 0" class="col-md-12">
          <h4 class="text-center" style="margin-bottom:20px;">
            Data Pembayaran Mahasiswa Belum dibuat.
            Silahkan untuk di buat terlebih dahulu
          </h4>
          <b-container fluid>
            <b-row class="my-1">
              <b-col sm="2">
                <label>Cara Pembayaran :</label>
              </b-col>
              <b-col sm="4">
                <b-form-select v-model="cara_pembayaran">
                  <b-form-select-option value="1">
                    Per Semester
                  </b-form-select-option>
                  <b-form-select-option value="2">
                    Cicilan
                  </b-form-select-option>
                </b-form-select>
              </b-col>
            </b-row>
            <b-row v-if="cara_pembayaran == 2" class="my-1">
              <b-col sm="2">
                <label>Total Cicilan :</label>
              </b-col>
              <b-col sm="4">
                <b-form-input v-model="total_cicilan" type="number" />
              </b-col>
            </b-row>
            <b-form-group style="margin: 20px 0px;">
              <b-form-radio v-model="rencana_pembayaran" name="rencana_pembayaran" value="1">
                Mahasiswa Membayar DPP Full, lalu membayaran SPP seperti biasa
              </b-form-radio>
              <b-form-radio v-model="rencana_pembayaran" name="rencana_pembayaran" value="2">
                Pembayaran DPP akan dibayarkan ke pembayaran SPP
              </b-form-radio>
            </b-form-group>
            <b-button variant="success" class="pull-left" @click="generate">
              Generate
            </b-button>
          </b-container>
        </div>
        <div v-else class="col-md-12">
          <table class="table table-bordered table-sm">
            <thead>
              <tr>
                <th>No</th>
                <th>Nama Pembayaran</th>
                <th>Waktu Pembayaran</th>
                <th>Sisa Pembayaran</th>
                <th>Aksi</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(data, index) in pembayaran_mahasiwa[0].rincian" :key="data.id">
                <td>{{ index+1 }}</td>
                <td>{{ data.nama_pembayaran }}</td>
                <td><b-form-datepicker :value="data.waktu_pembayaran" /></td>
                <td>Rp. {{ data.jumlah_pembayaran }}</td>
                <td>
                  <a v-if="data.is_lunas == false" v-b-modal.modal-rincian class="btn btn-info" @click="bayarRincian(data)">Bayar</a>
                  <a v-else v-b-modal.modal-rincian class="btn btn-success" @click="lihatHistory(data)">Cetak Kwitansi</a>
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
                    {{ rincian.nama_pembayaran }}
                  </td>
                </tr>
                <tr>
                  <td>
                    Sisa Pembayaran
                  </td>
                  <td>:</td>
                  <td>Rp. {{ rincian.jumlah_pembayaran }}</td>
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
      </div>
      <hr>
      <div v-if="table_generated" class="row">
        <div class="col-md-12">
          <table class="table table-bordered table-sm">
            <thead>
              <tr>
                <th>No</th>
                <th>Nama Pembayaran</th>
                <th>Waktu Pembayaran</th>
                <th>Jumlah Pembayaran</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(data, index) in table_data" :key="data.nama_pembayaran">
                <td>{{ index+1 }}</td>
                <td>{{ data.nama_pembayaran }}</td>
                <td><b-form-datepicker :value="data.waktu_pembayaran" /></td>
                <td>Rp. {{ data.jumlah_pembayaran }}</td>
              </tr>
            </tbody>
          </table>
          <div style="margin: 10px 0px;">
            <a class="btn btn-success" @click="submitDetail"> Submit </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Swal from 'sweetalert2'

export default {
  data () {
    return {
      id: this.$route.params.id,
      pembayaran_mahasiwa: [],
      cara_pembayaran: null,
      total_cicilan: 0,
      bayar: {
        catatan: null,
        jumlah: 0,
        sampai_tanggal: null
      },
      rincian: {
        id: 0,
        id_pembayaran_mahasiswa: 0,
        is_lunas: false,
        jumlah_pembayaran: 0,
        nama_pembayaran: '',
        waktu_pembayaran: ''
      },
      rencana_pembayaran: null,
      table_generated: false,
      table_data: [],
      id_pembayaran_mahasiswa: '',
      mahasiswa: {
        angkatan: {
          name: ''
        },
        kelas_mahasiswa: {
          kode: '',
          is_karyawan: false
        },
        prodi: {
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
        id: ''
      }
    }
  },
  mounted () {
    this.fetchPembayaran()
    this.fetchMahasiswa()
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
    lihatHistory (data) {
      alert('yo')
    },
    bayarRincian (data) {
      this.rincian = data
    },
    fetchPembayaran () {
      const query = `query getKeuanganPembayaranMahasiswa($id: Int!) {
                        keuangan_pembayaran_mahasiswa(where: {mahasiswa: {id: {_eq: $id}}}) {
                          cara_pembayaran
                          id
                          id_mahasiswa
                          is_dpp_full
                          total_cicilan
                          rincian(order_by: {id: asc}) {
                            id
                            id_pembayaran_mahasiswa
                            is_lunas
                            jumlah_pembayaran
                            nama_pembayaran
                            waktu_pembayaran
                            updated_at
                          }
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
          variables: { id: this.id }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error'); return }
          this.pembayaran_mahasiwa = gql.data.keuangan_pembayaran_mahasiswa
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    },
    generate () {
      if (this.cara_pembayaran === null || this.rencana_pembayaran === null) {
        alert('Inputan tidak boleh kosong')
        return
      }
      const table = []
      this.table_data = []
      let waktuPembayaran = new Date()
      if (this.rencana_pembayaran === '1') { // jika rencana pembayaran = Mahasiswa membayar DPP Full, lalu bayar spp seperti biasa
        table.push({
          nama_pembayaran: 'DPP',
          waktu_pembayaran: waktuPembayaran, // today
          jumlah_pembayaran: this.mahasiswa.biaya.biaya_dpp,
          tipe_rincian: 1
        })
      }

      // jika cara per semester (1)
      if (this.cara_pembayaran === '1') {
        const jarakHari = (30 * 6 * 24 * 60 * 60 * 1000)
        const bayar = (this.rencana_pembayaran === '1') ? this.mahasiswa.biaya.biaya_spp : ((this.mahasiswa.biaya.biaya_spp * 8) + this.mahasiswa.biaya.biaya_dpp) / 8
        for (let index = 1; index <= 8; index++) {
          table.push({
            nama_pembayaran: 'SPP Semester ' + index,
            waktu_pembayaran: waktuPembayaran,
            jumlah_pembayaran: bayar,
            tipe_rincian: 2
          })
          waktuPembayaran = new Date(waktuPembayaran.getTime() + jarakHari)
        }
      } else { // jika cara cicilan
        const jarakHari = (365 * 4 * 24 * 60 * 60 * 1000) / this.total_cicilan
        const bayar = (this.rencana_pembayaran) ? ((this.mahasiswa.biaya.biaya_spp * 8)) / this.total_cicilan : ((this.mahasiswa.biaya.biaya_spp * 8) + this.mahasiswa.biaya.biaya_dpp) / this.total_cicilan
        for (let index = 1; index <= this.total_cicilan; index++) {
          table.push({
            nama_pembayaran: 'Cicilan ke ' + index,
            waktu_pembayaran: waktuPembayaran,
            jumlah_pembayaran: bayar,
            tipe_rincian: 3
          })
          waktuPembayaran = new Date(waktuPembayaran.getTime() + jarakHari)
        }
      }
      this.table_data = table
      this.table_generated = true
    },
    async submitKwitansi () {
      // insert ke pembayaran kwitansi dan rubah jadi lunas di rincian
      const query = `mutation insert_kwitansi_spp_dpp($sampai_tanggal: date!, $id_mahasiswa: Int!, $catatan: String!, $id_pembayaran_mahasiswa_rincian: Int!, $jumlah: Int!) {
                      insert_keuangan_pembayaran_mahasiswa_kwitansi_one(object: {catatan: $catatan, id_pembayaran_mahasiswa_rincian: $id_pembayaran_mahasiswa_rincian, jumlah: $jumlah}) {
                        catatan
                        created_at
                        created_by
                        id
                        jumlah
                        id_pembayaran_mahasiswa_rincian
                        updated_at
                      }
                      update_keuangan_pembayaran_mahasiswa_rincian_by_pk(pk_columns: {id: $id_pembayaran_mahasiswa_rincian}, _set: {is_lunas: true}) {
                        created_by
                        created_at
                        id
                        id_pembayaran_mahasiswa
                        is_lunas
                        jumlah_pembayaran
                        nama_pembayaran
                        updated_at
                        waktu_pembayaran
                      }
                      insert_mahasiswa_pakai_sistem_one(object: {id_mahasiswa: $id_mahasiswa, sampai_tanggal: $sampai_tanggal}) {
                        id_mahasiswa
                        sampai_tanggal
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
            id_pembayaran_mahasiswa_rincian: this.rincian.id,
            jumlah: this.bayar.jumlah,
            id_mahasiswa: this.mahasiswa.id,
            sampai_tanggal: this.bayar.sampai_tanggal
          }
        })
      }).then(res => res.json())
        .then((gql) => {
          if (gql.data) {
            this.$bvModal.hide('modal-rincian')
            this.fetchPembayaran()
            Swal.fire({
              icon: 'success',
              title: 'SPP/DPP Berhasil Dibayarkan',
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
          this.id_pembayaran_mahasiswa = gql.data.insert_keuangan_pembayaran_mahasiswa_one.id
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    },
    async submitDetail () {
      // insert master nya dulu
      const query = `mutation MyMutation($cara_pembayaran: Int!, $id_mahasiswa: Int!, $is_dpp_full: Boolean!, $total_cicilan: Int) {
                      insert_keuangan_pembayaran_mahasiswa_one(object: {cara_pembayaran: $cara_pembayaran, id_mahasiswa: $id_mahasiswa, is_dpp_full: $is_dpp_full, total_cicilan: $total_cicilan}) {
                        cara_pembayaran
                        created_at
                        created_by
                        id
                        id_mahasiswa
                        is_dpp_full
                        total_cicilan
                        updated_at
                      }
                    }`
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
            cara_pembayaran: this.cara_pembayaran,
            id_mahasiswa: this.mahasiswa.id,
            is_dpp_full: this.rencana_pembayaran,
            total_cicilan: this.total_cicilan
          }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) {
            alert('Error 403 Server Error')
            return
          }
          this.id_pembayaran_mahasiswa = gql.data.insert_keuangan_pembayaran_mahasiswa_one.id
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })

      // insert anak nya
      const rincian = []
      for (let i = 0; i < this.table_data.length; i++) {
        rincian.push({
          id_pembayaran_mahasiswa: this.id_pembayaran_mahasiswa,
          is_lunas: false,
          jumlah_pembayaran: this.table_data[i].jumlah_pembayaran,
          nama_pembayaran: this.table_data[i].nama_pembayaran,
          waktu_pembayaran: this.table_data[i].waktu_pembayaran,
          tipe_rincian: this.table_data[i].tipe_rincian
        })
      }
      const query2 = `mutation insertKeuanganMahasiswaFirstTime($rincian: [keuangan_pembayaran_mahasiswa_rincian_insert_input!]!) {
                        insert_keuangan_pembayaran_mahasiswa_rincian(objects: $rincian) {
                          affected_rows
                        }
                      }`
      await fetch(process.env.gql, {
        method: 'post',
        headers: {
          Authorization: `Bearer ${this.$cookies.get('token')}`,
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'x-hasura-role': this.$cookies.get('role')
        },
        body: JSON.stringify({
          query: query2,
          variables: { rincian }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error'); return }
          Swal.fire({
            icon: 'success',
            title: 'Data Master Pembayaran mahasiswa berhasil di tambahkan',
            showConfirmButton: false
          })
          this.fetchPembayaran()
          this.table_generated = false
          return true
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    },
    fetchMahasiswa () {
      const id = this.id
      const query = `query getOneMahasiswa($id: Int!) {
                      mahasiswa(where: {id: {_eq: $id}}, limit: 1) {
                        angkatan {
                          name
                        }
                        kelas_mahasiswa {
                          kode
                        }
                        prodi {
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
          variables: { id }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error'); return }
          if (gql.data.mahasiswa[0].biaya === null) {
            alert('Angkatan/Prodi belum di tentukan untuk mahasiswa ini atau mahasiswa belum lulus dari tes penerimaan. Tidak bisa generate pembayaran.')
            this.$router.push({ path: '/spp-dpp/' })
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
