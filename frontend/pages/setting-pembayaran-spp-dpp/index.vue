<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h2 class="text-center">
        Setting Pembayaran SPP/DPP
      </h2>
      <a style="margin: 7px;" class="btn btn-success pull-right" @click="tambah = !tambah"><i class="fas fa-plus-square" /> Tambah Setting Pembayaran</a>
      <a style="margin: 7px;" class="btn btn-info pull-right" @click="filter = !filter"><i class="fas fa-filter" />Filter</a>
      <div v-if="tambah" class="col-md-6 filter">
        <h5>Tambah Data :</h5>
        <form @submit.prevent="tambahSetting">
          <b-row class="form-group">
            <b-col sm="3">
              <label>Angkatan :</label>
            </b-col>
            <b-col sm="7">
              <b-form-select v-model="id_angkatan" size="sm">
                <b-form-select-option v-for="data in angkatan" :key="data.id" :value="data.id">
                  {{ data.name }}
                </b-form-select-option>
              </b-form-select>
            </b-col>
          </b-row>
          <b-row class="form-group">
            <b-col sm="3">
              <label>Jurusan :</label>
            </b-col>
            <b-col sm="7">
              <b-form-select v-model="id_prodi" size="sm">
                <b-form-select-option v-for="data in jurusan" :key="data.id" :value="data.id">
                  {{ data.nama }}
                </b-form-select-option>
              </b-form-select>
            </b-col>
          </b-row>
          <b-row class="form-group">
            <b-col sm="3">
              <label>Jenis Kelas :</label>
            </b-col>
            <b-col sm="7">
              <b-form-select v-model="is_karyawan" size="sm">
                <b-form-select-option value="0">
                  Reguler
                </b-form-select-option>
                <b-form-select-option value="1">
                  Karyawan
                </b-form-select-option>
              </b-form-select>
            </b-col>
          </b-row>
          <b-row class="form-group">
            <b-col sm="3">
              <label>Biaya DPP :</label>
            </b-col>
            <b-col sm="7">
              <b-form-input v-model="biaya_dpp" type="number" />
            </b-col>
          </b-row>
          <b-row class="form-group">
            <b-col sm="3">
              <label>Biaya SPP :</label>
            </b-col>
            <b-col sm="7">
              <b-form-input v-model="biaya_spp" type="number" />
            </b-col>
          </b-row>
          <button type="submit" class="btn btn-sm btn-success">
            Tambah
          </button>
        </form>
      </div>
      <div v-if="filter" class="col-md-6 filter">
        <h5>Filter :</h5>
        <form @submit.prevent="fetchSettingPembayaran">
          <b-row class="form-group">
            <b-col sm="3">
              <label>Angkatan :</label>
            </b-col>
            <b-col sm="7">
              <b-form-select v-model="id_angkatan" size="sm">
                <b-form-select-option v-for="data in angkatan" :key="data.id" :value="data.id">
                  {{ data.name }}
                </b-form-select-option>
              </b-form-select>
            </b-col>
          </b-row>
          <b-row class="form-group">
            <b-col sm="3">
              <label>Jurusan :</label>
            </b-col>
            <b-col sm="7">
              <b-form-select v-model="id_prodi" size="sm">
                <b-form-select-option v-for="data in jurusan" :key="data.id" :value="data.id">
                  {{ data.nama }}
                </b-form-select-option>
              </b-form-select>
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
              Jurusan
            </th>
            <th>
              Angkatan
            </th>
            <th>
              Jenis Kelas
            </th>
            <th>
              Biaya SPP
            </th>
            <th>
              Biaya DPP
            </th>
            <th>Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(data, index) in setting_pembayaran" :key="data.id" class="text-center">
            <td>{{ (page == 1) ? index + 1 : (page * 10) + index - limit + 1 }}</td>
            <td>
              {{ data.jurusan.nama }}
            </td>
            <td>
              {{ data.angkatan.name }}
            </td>
            <td>
              {{ (data.is_karyawan) ? 'Karyawan' : 'Reguler' }}
            </td>
            <td>
              {{ data.biaya_spp }}
            </td>
            <td>
              {{ data.biaya_dpp }}
            </td>
            <td><a class="btn btn-info"> Detail </a></td>
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
import axios from 'axios'
import Swal from 'sweetalert2'

export default {
  data () {
    return {
      setting_pembayaran: [
        {
          id: '',
          biaya_dpp: '',
          biaya_spp: '',
          is_karyawan: false,
          angkatan: {
            name: ''
          },
          jurusan: {
            nama: ''
          }
        }
      ],
      angkatan: [
        {
          id: '',
          name: ''
        }
      ],
      jurusan: [
        {
          id: '',
          nama: ''
        }
      ],
      limit: 10,
      offset: 0,
      nim: null,
      id_prodi: null,
      id_angkatan: null,
      is_karyawan: false,
      biaya_dpp: 0,
      biaya_spp: 0,
      total_row: 0,
      page: 1,
      filter: false,
      tambah: false
    }
  },
  mounted () {
    this.fetchSettingPembayaran()
  },
  methods: {
    resetFilter () {
      this.nim = null
      this.id_prodi = null
      this.id_angkatan = null
      this.fetchSettingPembayaran()
    },
    handlePageChange (value) {
      this.page = value
      this.offset = (this.page - 1) * this.limit
      this.fetchSettingPembayaran()
    },
    tambahSetting () {
      axios({
        method: 'post',
        url: process.env.url + '/setting-pembayaran/create',
        data: {
          id_angkatan: this.id_angkatan,
          id_prodi: this.id_prodi,
          is_karyawan: this.is_karyawan,
          biaya_dpp: this.biaya_dpp,
          biaya_spp: this.biaya_spp
        }
      }).then((response) => {
        Swal.fire({
          icon: 'success',
          title: 'Data Berhasil di tambahkan',
          showConfirmButton: false
        })
        this.id_angkatan = ''
        this.id_prodi = ''
        this.fetchSettingPembayaran()
      }).catch((error) => {
        Swal.fire({
          icon: 'error',
          title: error.response.data.message,
          showConfirmButton: false
        })
      })
    },
    fetchSettingPembayaran () {
      const query = `query getSettingPembayaran($limit: Int = 10, $offset: Int = 0, $id_prodi: uuid, $id_angkatan: Int) {
                      setting_pembayaran(limit: $limit, offset: $offset, where: {jurusan: {id: {_eq: $id_prodi}}, id_angkatan: {_eq: $id_angkatan}}) {
                        biaya_dpp
                        biaya_spp
                        id
                        is_karyawan
                        angkatan {
                          name
                        }
                        jurusan {
                          nama
                        }
                      }
                      angkatan(order_by: {name: asc}) {
                        id
                        name
                      }
                      master_prodi {
                        id
                        nama
                      }
                    }`
      const limit = this.limit
      const offset = this.offset
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
          variables: { limit, offset, id_prodi, id_angkatan }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.setting_pembayaran = gql.data.setting_pembayaran
          this.angkatan = gql.data.angkatan
          this.jurusan = gql.data.master_prodi
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
    padding-left: 15px;
  }

  th {
      padding-left: 15px;
  }
</style>
