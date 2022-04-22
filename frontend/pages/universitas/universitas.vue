<template>
  <div class="col-md-12">
    <b-container fluid>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Nama Universitas :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="universitas.nama" class="uppercase" type="text" />
        </b-col>
      </b-row>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Alamat :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="universitas.alamat" class="uppercase" type="text" />
        </b-col>
      </b-row>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Kode Pos :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="universitas.kode_pos" type="text" />
        </b-col>
      </b-row>
      <b-row class="my-1">
        <b-col sm="3">
          <label>No Telp :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="universitas.telp" class="uppercase" type="text" />
        </b-col>
      </b-row>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Provinsi :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="universitas.provinsi" class="uppercase" type="text" />
        </b-col>
      </b-row>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Kota :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="universitas.kota" class="uppercase" type="text" />
        </b-col>
      </b-row>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Kecamatan :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="universitas.kecamatan" class="uppercase" type="text" />
        </b-col>
      </b-row>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Kelurahan :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="universitas.kelurahan" class="uppercase" type="text" />
        </b-col>
      </b-row>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Email :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="universitas.email" type="text" />
        </b-col>
      </b-row>
      <b-row class="my-1">
        <b-col sm="3">
          <label>Website :</label>
        </b-col>
        <b-col sm="9">
          <b-form-input v-model="universitas.website" type="text" />
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
      universitas: {
        nama: '',
        alamat: '',
        kode_pos: '',
        telp: '',
        provinsi: '',
        kota: '',
        kecamatan: '',
        kelurahan: '',
        email: '',
        website: ''
      }

    }
  },
  mounted () {
    this.fetchUniversitas()
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
          query: `mutation updateMasterUniversitas {
                  update_master_universitas_by_pk(pk_columns: {id: 10}, _set: {alamat: "${this.universitas.alamat}", email: "${this.universitas.email}", id: 10, kecamatan: "${this.universitas.kecamatan}", kelurahan: "${this.universitas.kelurahan}", kode_pos: "${this.universitas.kode_pos}", kota: "${this.universitas.kota}", nama: "${this.universitas.nama}", provinsi: "${this.universitas.provinsi}", telp: "${this.universitas.telp}", website: "${this.universitas.website}"}) {
                    email
                    kecamatan
                    kelurahan
                    kode_pos
                    kota
                    nama
                    provinsi
                    telp
                    website
                    alamat
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
              title: 'Data Universitas berhasil di simpan',
              showConfirmButton: false
            })
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
    fetchUniversitas () {
      fetch(process.env.gql, {
        method: 'post',
        headers: {
          Authorization: `Bearer ${this.$cookies.get('token')}`,
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'x-hasura-role': this.$cookies.get('role')
        },
        body: JSON.stringify({
          query: `query getUniversitas {
                  master_universitas(limit: 1) {
                    alamat
                    email
                    id
                    kecamatan
                    kelurahan
                    kode_pos
                    kota
                    nama
                    provinsi
                    telp
                    website
                  }
                }

                `
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.universitas = gql.data.master_universitas[0]
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    }
  }
}
</script>

<style scoped>
  .uppercase {
    text-transform: uppercase;
  }
</style>
