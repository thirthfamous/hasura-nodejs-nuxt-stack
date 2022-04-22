<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h2 class="text-center">
        Setting Pembayaran Angkatan {{ this.angkatan.name }}
      </h2>
      <table class="table table-bordered table-sm table-sm">
        <thead>
          <tr class="text-center">
            <th>No</th>
            <th>
              Nama Jurusan
            </th>
            <th>Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(data, index) in jurusan" :key="data.id" class="text-center">
            <td>{{ index + 1 }}</td>
            <td>
              {{ data.nama }}
            </td>
            <td><a class="btn btn-info" @click="redirectToSelectIsKaryawan(data.id)"> Detail </a></td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
<script>

export default {
  data () {
    return {
      jurusan: [],
      angkatan: {
        id: 0,
        name: ''
      }
    }
  },
  mounted () {
    this.fetchJurusan()
  },
  methods: {
    redirectToSelectIsKaryawan (id) {
      this.$router.push({ path: `/setting-pembayaran-misc/${this.$route.params.id_angkatan}/${id}` })
    },
    fetchJurusan () {
      const query = `query getJurusan($id_angkatan: Int!, $id1: Int = 10) {
  master_prodi {
    id
    nama
  }
  angkatan_by_pk(id: $id_angkatan) {
    id
    name
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
          variables: {
            id_angkatan: this.$route.params.id_angkatan
          }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.jurusan = gql.data.master_prodi
          this.angkatan = gql.data.angkatan_by_pk
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
