<template>
  <div>
    <h2 class="text-center" v-if="$route.name == 'setting-pembayaran-misc'">
    Silahkan pilih angkatan
  </h2>
  <table class="table table-bordered table-sm table-sm">
    <thead>
      <tr class="text-center">
        <th>No</th>
        <th>
          Nama
        </th>
        <th>
          Deskripsi
        </th>
        <th>Aksi</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="(data, index) in angkatan" :key="data.id" class="text-center">
        <td>{{ index + 1 }}</td>
        <td>
          {{ data.name }}
        </td>
        <td>
          {{ data.deskripsi }}
        </td>
        <td><a class="btn btn-info" @click="redirectToSelectProdi(data.id, data.name)"> Detail </a></td>
      </tr>
    </tbody>
  </table>
  </div>
</template>

<script>
export default {
  data () {
    return {
      angkatan: [
        {
          name: '',
          deskripsi: ''
        }
      ],
      angkatan_name: ''
    }
  },
  mounted () {
    this.angkatan = this.fetchAngkatan()
  },
  methods: {
    redirectToSelectProdi (id, name) {
      this.$router.push({ path: `/setting-pembayaran-misc/${id}` })
      this.angkatan_name = name
    },
    fetchAngkatan () {
      fetch(process.env.gql, {
        method: 'post',
        headers: {
          Authorization: `Bearer ${this.$cookies.get('token')}`,
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'x-hasura-role': this.$cookies.get('role')
        },
        body: JSON.stringify({
          query: `query getAngkatan {
                    angkatan(order_by: {id: asc}) {
                      id
                      name
                      deskripsi
                    }
                  }
                 `
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.angkatan = gql.data.angkatan
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
