<template>
  <div class="col-md-12">
    <b-container fluid>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Nama Program Studi :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="prodi.nama" class="uppercase" type="text" />
        </b-col>
      </b-row>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Pilih Fakultas :</label>
        </b-col>
        <b-col sm="9">
          <b-form-select v-model="prodi.id_fakultas">
            <b-form-select-option v-for="data in fakultas" :key="data.id" :value="data.id">
              {{ data.nama }}
            </b-form-select-option>
          </b-form-select>
        </b-col>
      </b-row>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Kode Prodi :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="prodi.kode" type="text" />
        </b-col>
      </b-row>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Deskripsi :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="prodi.deskripsi" class="uppercase" type="text" />
        </b-col>
      </b-row>
      <b-button variant="success" class="pull-right" @click="save">
        <i class="fas fa-save" />
        Save
      </b-button>
    </b-container>
  </div>
</template>

<script>
import Swal from 'sweetalert2'

export default {
  data () {
    return {
      prodi: {
        nama: '',
        deskripsi: '',
        kode: '',
        id_fakultas: ''
      },
      fakultas: {
        id: '',
        nama: ''
      }
    }
  },
  mounted () {
    this.fetchFakultas()
  },
  methods: {
    save () {
      const query = `mutation MyMutation($deskripsi: String!, $nama: String!, $id_fakultas: uuid!, $kode: String!) {
                    insert_master_prodi_one(object: {deskripsi: $deskripsi, nama: $nama, id_fakultas: $id_fakultas, kode: $kode}) {
                      nama
                      deskripsi
                      kode
                    }
                  }`
      const deskripsi = this.prodi.deskripsi
      const nama = this.prodi.nama
      const kode = this.prodi.kode
      // eslint-disable-next-line camelcase
      const id_fakultas = this.prodi.id_fakultas
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
          variables: { deskripsi, nama, id_fakultas, kode }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.data) {
            Swal.fire({
              icon: 'success',
              title: 'Data Program Studi berhasil di simpan',
              showConfirmButton: false
            })
            this.$router.push({ path: '/universitas/prodi/' })
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
    fetchFakultas () {
      fetch(process.env.gql, {
        method: 'post',
        headers: {
          Authorization: `Bearer ${this.$cookies.get('token')}`,
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'x-hasura-role': this.$cookies.get('role')
        },
        body: JSON.stringify({
          query: `query getFakultas {
                    master_fakultas {
                      id
                      nama
                    }
                  }
                  `
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.fakultas = gql.data.master_fakultas
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    }
  }
}
</script>
