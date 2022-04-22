<template>
  <div class="col-md-12">
    <NuxtLink to="/universitas/fakultas/tambah" class="btn btn-success pull-right" style="margin-bottom: 20px">
      <i class="fas fa-plus-square" /> Tambah Fakultas
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
        <tr v-for="(data, index) in fakultas" :key="data.id" class="text-center">
          <td>{{ index + 1 }}</td>
          <td>
            {{ data.nama }}
          </td>
          <td><a class="btn btn-info"> Detail </a></td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script>
export default {
  data () {
    return {
      fakultas: [
        {
          nama: '',
          deskripsi: ''
        }
      ]
    }
  },
  mounted () {
    this.fakultas = this.fetchFakultas()
  },
  methods: {
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
                      deskripsi
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
