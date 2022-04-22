<template>
  <div class="col-md-12">
    <b-container fluid>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Nama Fakultas :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="fakultas.nama" class="uppercase" type="text" />
        </b-col>
      </b-row>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Deskripsi :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="fakultas.deskripsi" class="uppercase" type="text" />
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
      fakultas: {
        nama: '',
        deskripsi: ''
      }
    }
  },
  methods: {
    save () {
      fetch(process.env.gql, {
        method: 'post',
        headers: {
          Authorization: `Bearer ${this.$cookies.get('token')}`,
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'x-hasura-role': this.$cookies.get('role')
        },
        body: JSON.stringify({
          query: `mutation insertFakultas {
                    insert_master_fakultas_one(object: {deskripsi: "${this.fakultas.deskripsi}", nama: "${this.fakultas.nama}"}) {
                      nama
                      deskripsi
                      id
                      created_at
                    }
                  }
                  `
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.data) {
            Swal.fire({
              icon: 'success',
              title: 'Data Fakultas berhasil di simpan',
              showConfirmButton: false
            })
            this.$router.push({ path: '/universitas/fakultas/' })
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
    }
  }
}
</script>
