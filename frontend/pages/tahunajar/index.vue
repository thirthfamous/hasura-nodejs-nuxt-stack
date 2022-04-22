<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h2 class="text-center">
        Tahun Ajar
      </h2>
      <NuxtLink to="/tahunajar/tambah" class="btn btn-success pull-right" style="margin-bottom: 20px">
        <i class="fas fa-plus-square" /> Tambah Tahun Ajar
      </NuxtLink>
      <table class="table table-bordered table-sm table-sm">
        <thead>
          <tr class="text-center">
            <th>No</th>
            <th>
              Nama
            </th>
            <th>Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(data, index) in tahun_ajar" :key="data.id" class="text-center">
            <td>{{ index + 1 }}</td>
            <td>
              {{ data.name }}
            </td>
            <td><a class="btn btn-info"> Detail </a></td>
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
      tahun_ajar: [
        {
          name: ''
        }
      ]
    }
  },
  mounted () {
    this.tahun_ajar = this.fetchTahunAjar()
  },
  methods: {
    fetchTahunAjar () {
      fetch(process.env.gql, {
        method: 'post',
        headers: {
          Authorization: `Bearer ${this.$cookies.get('token')}`,
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'x-hasura-role': this.$cookies.get('role')
        },
        body: JSON.stringify({
          query: `query getTahunAjar {
                    tahun_ajar(order_by: {id: asc}) {
                      id
                      name
                    }
                  }`
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.tahun_ajar = gql.data.tahun_ajar
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
