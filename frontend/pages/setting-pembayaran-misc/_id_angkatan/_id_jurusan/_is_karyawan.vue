<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h2 class="text-center">
        Setting Pembayaran Jurusan {{ this.jurusan }}
      </h2>
      <h2 class="text-center">
        Angkatan {{ this.angkatan }}
      </h2>
      <h2 class="text-center">
        Kelas {{ ($route.params.is_karyawan === '1') ? 'Reguler' : 'Karyawan' }}
      </h2>
      <table class="table table-bordered table-sm table-sm">
        <thead>
          <tr class="text-center">
            <th>No</th>
            <th>
              Nama Pembayaran
            </th>
            <th>
              Biaya
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(data, index) in setting_pembayaran_other" :key="data.id" class="text-center">
            <td>{{ index + 1 }}</td>
            <td>
              {{ data.keuangan_tipe_pembayaran.nama }}
            </td>
            <td>
              <div class="col-lg-6 offset-lg-3">
                <input v-model="data.biaya" class="form-control" type="number">
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      <a class="btn btn-primary pull-right" @click="updateSetting">Update</a>
    </div>
  </div>
</template>
<script>
import Swal from 'sweetalert2'
import axios from 'axios'

export default {
  data () {
    return {
      setting_pembayaran_other: [
        {
          id: 0,
          id_angkatan: 0,
          id_jurusan: '',
          id_tipe_pembayaran: 0,
          biaya: 0,
          is_karyawan: false,
          keuangan_tipe_pembayaran: {
            nama: ''
          }
        }
      ],
      angkatan: '',
      jurusan: ''
    }
  },
  mounted () {
    this.fetchSettingPembayaran()
  },
  methods: {
    updateSetting () {
      axios({
        method: 'post',
        url: process.env.url + '/setting-pembayaran-other/update',
        data: {
          data: this.setting_pembayaran_other
        }
      }).then((response) => {
        Swal.fire({
          icon: 'success',
          title: response.data.message,
          showConfirmButton: false
        })
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
      const query = `query getSettingPembayaranOther($id_angkatan: Int!, $id_jurusan: uuid!, 
  $is_karyawan: Boolean!) {
  setting_pembayaran_other(where: {id_angkatan: {_eq: $id_angkatan}, 
    id_jurusan: {_eq: $id_jurusan}, 
    is_karyawan: {_eq: $is_karyawan}}, order_by: {id: asc}) {
    id
    id_angkatan
    id_jurusan
    id_tipe_pembayaran
    is_karyawan
    biaya
    keuangan_tipe_pembayaran {
      nama
    }
  }
  angkatan_by_pk(id: $id_angkatan) {
    name
  }
  master_prodi_by_pk(id: $id_jurusan) {
    nama
  }
}
`
      // eslint-disable-next-line camelcase
      const id_angkatan = parseInt(this.$route.params.id_angkatan)
      // eslint-disable-next-line camelcase
      const id_jurusan = this.$route.params.id_jurusan
      // eslint-disable-next-line camelcase
      const is_karyawan = this.$route.params.is_karyawan !== '1'

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
          variables: { id_jurusan, id_angkatan, is_karyawan }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.setting_pembayaran_other = gql.data.setting_pembayaran_other
          this.angkatan = gql.data.angkatan_by_pk.name
          this.jurusan = gql.data.master_prodi_by_pk.nama
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
