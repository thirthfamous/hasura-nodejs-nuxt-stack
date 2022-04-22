<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h3 class="text-center" style="margin-bottom:30px;">
        Tambah Tahun Ajar
      </h3>
      <b-container fluid>
        <b-row class="my-1">
          <b-col sm="3">
            <label>Tahun Ajar :</label>
          </b-col>
          <b-col sm="9">
            <b-form-input v-model="name" type="text" />
          </b-col>
        </b-row>
        <b-button variant="success" class="pull-right" @click="save">
          <i class="fas fa-save" />
          Save
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
      name: '',
      deskripsi: ''
    }
  },
  methods: {
    save () {
      const query = `mutation MyMutation($name: String!) {
                      insert_tahun_ajar_one(object: {name: $name}) {
                        id
                        name
                      }
                    }
                    `
      const name = this.name
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
          variables: { name }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.data) {
            Swal.fire({
              icon: 'success',
              title: 'Tahun Ajar Berhasil di tambahkan',
              showConfirmButton: false
            })
            this.$router.push({ path: '/tahunajar/' })
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

<style scoped>
  .bg-white {
    padding: 20px;
  }
</style>
