<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h3 class="text-center" style="margin-bottom:30px;">
        Tambah Jurnal
      </h3>
      <b-container fluid>
        <b-row class="my-1">
          <b-col sm="3">
            <label>Kode Akun :</label>
          </b-col>
          <b-col sm="9">
            <v-select v-model="kode_akun" label="name" :options="akun_options" />
            <!-- <b-form-select v-model="kode_akun" size="sm"> -->
            <!-- <b-form-select-option>
                  -- Silahkan Pilih Akun --
                </b-form-select-option>
                <b-form-select-option v-for="data in akuntansi_master_akun" :key="data.kode" :value="data.kode">
                  {{ data.kode }} - {{ data.nama }}
                </b-form-select-option> -->
            <!-- </b-form-select> -->
          </b-col>
        </b-row>
        <b-row class="my-1">
          <b-col sm="3">
            <label>Tanggal :</label>
          </b-col>
          <b-col sm="9">
            <b-form-datepicker v-model="tanggal" size="sm" />
          </b-col>
        </b-row>
        <b-row class="my-1">
          <b-col sm="3">
            <label>Keterangan :</label>
          </b-col>
          <b-col sm="9">
            <b-form-textarea
              v-model="keterangan"
              placeholder="Isi Keterangan..."
              rows="3"
              size="sm"
            />
          </b-col>
        </b-row>
        <b-row class="my-1">
          <b-col sm="3">
            <label>Referensi :</label>
          </b-col>
          <b-col sm="9">
            <b-form-input
              v-model="ref"
              type="text"
              size="sm"
              placeholder="Isi Referensi..."
            />
          </b-col>
        </b-row>
        <b-row class="my-1">
          <b-col sm="3">
            <label>Debit :</label>
          </b-col>
          <b-col sm="9">
            <b-form-input
              v-model="debit"
              type="number"
              size="sm"
              placeholder="Isi Nilai Debit..."
            />
          </b-col>
        </b-row>
        <b-row class="my-1">
          <b-col sm="3">
            <label>Kredit :</label>
          </b-col>
          <b-col sm="9">
            <b-form-input
              v-model="kredit"
              type="number"
              size="sm"
              placeholder="Isi Nilai Kredit..."
            />
          </b-col>
        </b-row>
        <template v-if="is_subledger">
          <b-row my-1 class="bg-master-subledger">
            <b-col sm="3">
              <label><b>Master Subledger :</b></label>
            </b-col>
            <b-col sm="5">
              <b-row class="my-1">
                <b-col sm="3">
                  <label>Kode :</label>
                </b-col>
                <b-col sm="8">
                  <b-form-input
                    v-model="kode_akun.kode"
                    readonly
                    type="text"
                    size="sm"
                    placeholder="Harap Mengisi Kode Akun..."
                  />
                </b-col>
              </b-row>
              <b-row class="my-1">
                <b-col sm="3">
                  <label>ID Subledger :</label>
                </b-col>
                <b-col sm="8">
                  <b-form-input
                    v-model="id_master_subledger"
                    type="number"
                    size="sm"
                    placeholder="ID Subledger..."
                  />
                </b-col>
              </b-row>
              <b-row class="my-1">
                <b-col sm="3">
                  <b-button variant="warning" class="btn-sm" @click="checkSubledger">
                    <i class="fas fa-search" />
                    Check
                  </b-button>
                </b-col>
              </b-row>
            </b-col>
            <b-col sm="4">
              <b-row class="my-1">
                <b-col sm="3">
                  <label>Nama :</label>
                </b-col>
                <b-col sm="9">
                  <p>{{ akuntansi_master_subledger.nama }}</p>
                </b-col>
              </b-row>
              <b-row class="my-1">
                <b-col sm="3">
                  <label>Kredit :</label>
                </b-col>
                <b-col sm="9">
                  <p>{{ formatRupiah(akuntansi_master_subledger.kredit, 'Rp. ') }}</p>
                </b-col>
              </b-row>
              <b-row class="my-1">
                <b-col sm="3">
                  <label>Debit :</label>
                </b-col>
                <b-col sm="9">
                  <p>{{ formatRupiah(akuntansi_master_subledger.debit, 'Rp. ') }}</p>
                </b-col>
              </b-row>
            </b-col>
          </b-row>
          <template v-if="valid_master_subledger">
            <b-row my-1 class="bg-transaksi-subledger">
              <b-col sm="3">
                <label><b>Transaksi Subledger :</b></label>
              </b-col>
              <b-col sm="5">
                <b-row class="my-1">
                  <b-col sm="3">
                    <label>Keterangan :</label>
                  </b-col>
                  <b-col sm="9">
                    <b-form-textarea
                      v-model="keterangan_subledger"
                      placeholder="Isi Keterangan..."
                      rows="3"
                      size="sm"
                    />
                  </b-col>
                </b-row>
                <b-row class="my-1">
                  <b-col sm="3">
                    <label>Debit :</label>
                  </b-col>
                  <b-col sm="9">
                    <b-form-input
                      v-model="debit_subledger"
                      type="number"
                      size="sm"
                      placeholder="Isi Nilai Debit..."
                    />
                  </b-col>
                </b-row>
                <b-row class="my-1">
                  <b-col sm="3">
                    <label>Kredit :</label>
                  </b-col>
                  <b-col sm="9">
                    <b-form-input
                      v-model="kredit_subledger"
                      type="number"
                      size="sm"
                      placeholder="Isi Nilai Kredit..."
                    />
                  </b-col>
                </b-row>
                <b-row class="my-1">
                  <b-col sm="3">
                    <label>Referensi :</label>
                  </b-col>
                  <b-col sm="9">
                    <b-form-input
                      v-model="ref_subledger"
                      type="text"
                      size="sm"
                      placeholder="Isi Referensi..."
                    />
                  </b-col>
                </b-row>
              </b-col>
            </b-row>
          </template>
        </template>
        <b-modal id="modal-tambah-master-subledger" title="Tambah Master Subledger" hide-footer size="lg">
          <div class="row">
            <div class="col-md-12">
              <table>
                <tr>
                  <td>
                    Kode
                  </td>
                  <td>:</td>
                  <td>
                    <input v-model="kode_akun.kode" type="number" readonly class="form-control">
                  </td>
                </tr>
                <tr>
                  <td>ID Subledger</td>
                  <td>:</td>
                  <td>
                    <input v-model="akuntansi_master_subledger.id_subledger" type="number" class="form-control">
                  </td>
                </tr>
                <tr>
                  <td>Nama Subledger</td>
                  <td>:</td>
                  <td>
                    <input v-model="akuntansi_master_subledger.nama" type="text" class="form-control">
                  </td>
                </tr>
                <tr>
                  <td>Kredit</td>
                  <td>:</td>
                  <td>
                    <input v-model="akuntansi_master_subledger.kredit" type="number" class="form-control">
                  </td>
                </tr>
                <tr>
                  <td>Debit</td>
                  <td>:</td>
                  <td>
                    <input v-model="akuntansi_master_subledger.debit" type="number" class="form-control">
                  </td>
                </tr>
              </table>
              <div>
                <small class="text-danger">Pastikan untuk mengecek kembali data yang di input. </small>
              </div>
              <div style="margin: 10px 0px;">
                <a class="btn btn-success" @click="showConfirmTambahMasterSubledger">Tambah</a>
              </div>
            </div>
          </div>
        </b-modal>

        <b-button variant="success" class="pull-right" @click="showConfirmModalJurnal">
          <i class="fas fa-save" />
          Save
        </b-button>
        <b-button variant="primary" class="pull-right" @click="toggleTambahSubledger">
          <i class="fas fa-bars" />
          {{ (!is_subledger) ? 'Tambah' : 'Sembunyikan' }} Subledger
        </b-button>
      </b-container>
    </div>
  </div>
</template>

<script>
import Swal from 'sweetalert2'

export default {
  data () {
    return {
      akuntansi_master_akun: [],
      kode_akun: '',
      tanggal: '',
      keterangan: '',
      ref: '',
      kredit: 0,
      debit: 0,
      akun_options: [],
      id_master_subledger: 0,
      kode_master_subledger: '',
      is_subledger: false,
      valid_master_subledger: false,
      akuntansi_master_subledger: {
        kode: '',
        id_subledger: '',
        nama: '',
        kredit: 0,
        debit: 0
      },
      keterangan_subledger: '',
      debit_subledger: 0,
      kredit_subledger: 0,
      ref_subledger: '',
      tanggal_subledger: ''
    }
  },
  mounted () {
    this.fetchData()
  },
  methods: {
    showConfirmTambahMasterSubledger () {
      const query = `mutation InsertOneMasterSubledger($debit: Int!, $id_subledger: String!, 
                      $kode: String!, $kredit: Int!, $nama: String!) {
                      insert_akuntansi_master_subledger_one(object: {id_subledger: $id_subledger, 
                        kode: $kode, kredit: $kredit, nama: $nama, debit: $debit}) {
                        id
                        id_subledger
                        kode
                        kredit
                        nama
                        debit
                      }
                    }
                    `
      const nama = this.akuntansi_master_subledger.nama
      const kode = this.kode_akun.kode
      const id_subledger = this.akuntansi_master_subledger.id_subledger
      const debit = this.akuntansi_master_subledger.debit
      const kredit = this.akuntansi_master_subledger.kredit
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
          variables: { debit, kredit, id_subledger, kode, nama }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.data) {
            Swal.fire({
              icon: 'success',
              title: 'Master Subledger Berhasil Ditambahkan',
              showConfirmButton: false
            })
            this.id_master_subledger = gql.data.insert_akuntansi_master_subledger_one.id_subledger
            this.kode_akun.kode = gql.data.insert_akuntansi_master_subledger_one.kode
            this.checkSubledger()
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
    async checkSubledger () {
      const query = `query getOneMasterSubledger($kode: String!, $id_subledger: String!) {
                      akuntansi_master_subledger(where: {kode: {_eq: $kode}, id_subledger: {_eq: $id_subledger}}) {
                        id
                        debit
                        id_subledger
                        kode
                        kredit
                        nama
                      }
                    }
                    `
      const id_subledger = this.id_master_subledger
      const kode = this.kode_akun.kode
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
          variables: { id_subledger, kode }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          if (gql.data.akuntansi_master_subledger.length === 0) {
            this.valid_master_subledger = false
            this.akuntansi_master_subledger = {
              kode: '',
              id_subledger: '',
              nama: '',
              kredit: 0,
              debit: 0
            }
            if (confirm('Data Master Subledger tidak ditemukan, apakah anda akan menambahkan data master subledger baru ?')) {
              this.$bvModal.show('modal-tambah-master-subledger')
            }
            return
          }
          this.akuntansi_master_subledger = gql.data.akuntansi_master_subledger[0]
          this.valid_master_subledger = true
        }).catch((error) => {
          alert('Terjadi Error')
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    },
    toggleTambahSubledger () {
      this.is_subledger = !this.is_subledger
    },
    showConfirmModalJurnal () {
      this.$bvModal.msgBoxConfirm('Tolong Pastikan Semua Data Di Input Dengan Tepat', {
        title: 'Apakah Anda Yakin Akan Mengentry Jurnal Ini ? ?',
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
            if (this.is_subledger) {
              this.saveWithSubledger()
            } else {
              this.save()
            }
          }
        })
        .catch((err) => {
          console.error('There was an error!', err)
        })
    },
    saveWithSubledger () {
      const query = `mutation InsertJurnalAndSubledger($kode_akun: String!, $tanggal: date!, $keterangan: String!, $ref: String!, $debit: Int!, $kredit: Int!, $keterangan_subledger: String!, $debit_subledger: Int!, $kredit_subledger: Int!, $ref_subledger: String!, $subledger_id: Int!, $tanggal_subledger: date!) {
      insert_akuntansi_jurnal_one(object: {kode_akun: $kode_akun, tanggal: $tanggal, keterangan: $keterangan, ref: $ref, debit: $debit, kredit: $kredit}) {
        id
        kode_akun
        tanggal
        ref
        keterangan
        debit
        kredit
      }
      insert_akuntansi_transaksi_subledger_one(object: {keterangan: $keterangan_subledger, 
        debit: $debit_subledger, kredit: $kredit_subledger, ref: $ref_subledger, 
        subledger_id: $subledger_id, tanggal: $tanggal_subledger}) {
        keterangan
        debit
        kredit
        ref
        subledger_id
        tanggal
      }
      }`
      const kode_akun = this.kode_akun.kode
      const tanggal = (this.tanggal) ? this.tanggal : null
      const keterangan = (this.keterangan) ? this.keterangan : null
      const ref = (this.ref) ? this.ref : null
      const kredit = this.kredit
      const debit = this.debit
      const keterangan_subledger = (this.keterangan_subledger) ? this.keterangan_subledger : null
      const debit_subledger = this.debit_subledger
      const kredit_subledger = this.kredit_subledger
      const ref_subledger = (this.ref_subledger) ? this.ref_subledger : null
      const subledger_id = (this.akuntansi_master_subledger.id) ? this.akuntansi_master_subledger.id : null
      const tanggal_subledger = (this.tanggal) ? this.tanggal : null
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
          variables: { kode_akun, tanggal, keterangan, ref, kredit, debit, keterangan_subledger, debit_subledger, kredit_subledger, ref_subledger, subledger_id, tanggal_subledger }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.data) {
            Swal.fire({
              icon: 'success',
              title: 'Jurnal Berhasil di tambahkan',
              showConfirmButton: false
            })
            this.$router.push({ path: '/jurnal/' })
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
    save () {
      const query = `mutation InsertJurnal($kode_akun: String!, $tanggal: date!, $keterangan: String!, $ref: String!, $debit: Int!, $kredit: Int!) {
                      insert_akuntansi_jurnal_one(object: {kode_akun: $kode_akun, tanggal: $tanggal, keterangan: $keterangan, ref: $ref, debit: $debit, kredit: $kredit}) {
                        id
                        kode_akun
                        tanggal
                        ref
                        keterangan
                        debit
                        kredit
                      }
                    }
                    `
      const kode_akun = this.kode_akun.kode
      const tanggal = (this.tanggal) ? this.tanggal : null
      const keterangan = (this.keterangan) ? this.keterangan : null
      const ref = (this.ref) ? this.ref : null
      const kredit = this.kredit
      const debit = this.debit
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
          variables: { kode_akun, tanggal, keterangan, ref, kredit, debit }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.data) {
            Swal.fire({
              icon: 'success',
              title: 'Jurnal Berhasil di tambahkan',
              showConfirmButton: false
            })
            this.$router.push({ path: '/jurnal/' })
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
      const query = `query GetAkunTipe {
                      akuntansi_master_akun(order_by: {kode: asc}) {
                        id_parent
                        id_tipe
                        kode
                        nama
                        saldo_normal
                        akuntansi_master_tipe {
                          nama
                        }
                      }
                    }`
      fetch(process.env.gql, {
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
          if (gql.error) { alert('Error 403 Server Error') }
          this.akuntansi_master_akun = gql.data.akuntansi_master_akun
          this.akuntansi_master_akun.forEach((element) => {
            this.akun_options.push({
              name: element.kode + ' - ' + element.nama,
              kode: element.kode
            })
          })
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
  .bg-master-subledger {
    background-color: rgb(230, 230, 230);
  }

  .bg-transaksi-subledger {
    background-color: rgb(215, 220, 250);
  }
</style>
