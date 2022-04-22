<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h2 class="text-center">
        Setting Chart of Account (Akuntansi)
      </h2>
      <a style="margin: 7px;" class="btn btn-success pull-right" @click="tambah = !tambah"><i class="fas fa-plus-square" /> Tambah Akun</a>
      <a style="margin: 7px;" class="btn btn-info pull-right" @click="filter = !filter"><i class="fas fa-filter" />Filter</a>
      <div v-if="tambah" class="col-md-6 filter">
        <h5>Tambah Data :</h5>
        <form @submit.prevent="tambahAkun">
          <b-row class="form-group">
            <b-col sm="3">
              <label>Kode :</label>
            </b-col>
            <b-col sm="7">
              <b-form-input v-model="kode" placeholder="Kode Akun" size="sm" />
            </b-col>
          </b-row>
          <b-row class="form-group">
            <b-col sm="3">
              <label>Nama :</label>
            </b-col>
            <b-col sm="7">
              <b-form-input v-model="nama" placeholder="Nama Akun" size="sm" />
            </b-col>
          </b-row>
          <b-row class="form-group">
            <b-col sm="3">
              <label>Tipe Akun :</label>
            </b-col>
            <b-col sm="7">
              <b-form-select v-model="id_tipe" size="sm">
                <b-form-select-option v-for="data in akuntansi_master_tipe" :key="data.id" :value="data.id">
                  {{ data.nama }} ({{ data.akuntansi_master_kategori.nama }})
                </b-form-select-option>
              </b-form-select>
            </b-col>
          </b-row>
          <b-row class="form-group">
            <b-col sm="3">
              <label>Akun Parent :</label>
            </b-col>
            <b-col sm="7">
              <b-form-select v-model="id_parent" size="sm">
                <b-form-select-option selected>
                  Tidak ada Parent
                </b-form-select-option>
                <b-form-select-option v-for="data in akuntansi_master_akun" :key="data.kode" :value="data.kode">
                  {{ data.kode }} - {{ data.nama }}
                </b-form-select-option>
              </b-form-select>
            </b-col>
          </b-row>
          <b-row class="form-group">
            <b-col sm="3">
              <label>Saldo Normal:</label>
            </b-col>
            <b-col sm="7">
              <b-form-select v-model="saldo_normal" size="sm">
                <b-form-select-option value="D" selected>
                  Debit
                </b-form-select-option>
                <b-form-select-option value="K">
                  Kredit
                </b-form-select-option>
              </b-form-select>
            </b-col>
          </b-row>
          <button type="submit" class="btn btn-sm btn-success">
            Tambah
          </button>
        </form>
      </div>
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
              Kode
            </th>
            <th>
              Nama Akun
            </th>
            <th>
              Kategori
            </th>
            <th class="text-center center">
              Saldo Normal
            </th>
            <th class="text-center center">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(data) in akuntansi_master_akun" :key="data.id">
            <template v-if="(id_tipe_filter === data.id_tipe) || (id_tipe_filter === '0')">
              <td>
                {{ data.kode }}
              </td>
              <td>
                {{ data.nama }}
              </td>
              <td>
                {{ data.akuntansi_master_tipe.nama }}
              </td>
              <td class="text-center center">
                {{ data.saldo_normal }}
              </td>
              <td class="text-center center"><a class="btn btn-danger"> Non-Aktifkan </a></td>
            </template>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
<script>
import Swal from 'sweetalert2'

export default {
  data () {
    return {
      akuntansi_master_tipe: [],
      akuntansi_master_kategori: [],
      akuntansi_master_akun: [],
      id_tipe_filter: '0',
      kode: '',
      id_parent: '',
      id_tipe: 0,
      saldo_normal: null,
      nama: '',
      filter: false,
      tambah: false
    }
  },
  mounted () {
    this.fetchData()
  },
  methods: {
    tambahAkun () {
      const nama = this.nama
      const kode = this.kode
      const id_parent = (this.id_parent) ? this.id_parent : null
      const id_tipe = this.id_tipe
      const saldo_normal = this.saldo_normal
      const query = `mutation InsertAkunOne($id_parent: Int, $id_tipe: Int!, $kode: String!, $nama: String!, $saldo_normal: String!) {
                      insert_akuntansi_master_akun_one(object: {nama: $nama, kode: $kode, id_tipe: $id_tipe, id_parent: $id_parent, saldo_normal: $saldo_normal}) {
                        id_parent
                        id_tipe
                        kode
                        nama
                        saldo_normal
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
          variables: { kode, nama, id_parent, id_tipe, saldo_normal }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.data) {
            Swal.fire({
              icon: 'success',
              title: 'Akun Berhasil di tambahkan',
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
    fetchData () {
      const query = `query GetAkunTipe {
                      akuntansi_master_tipe {
                        id
                        nama
                        id_kategori
                        akuntansi_master_kategori {
                          nama
                        }
                      }
                      akuntansi_master_kategori {
                        nama
                        id
                      }
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
          query
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.akuntansi_master_tipe = gql.data.akuntansi_master_tipe
          this.akuntansi_master_kategori = gql.data.akuntansi_master_kategori
          this.akuntansi_master_akun = gql.data.akuntansi_master_akun
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
