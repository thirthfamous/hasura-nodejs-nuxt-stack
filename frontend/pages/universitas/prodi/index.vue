<template>
  <div class="col-md-12">
    <NuxtLink to="/universitas/prodi/tambah" class="btn btn-success pull-right" style="margin-bottom: 20px">
      <i class="fas fa-plus-square" /> Tambah Program Studi
    </NuxtLink>
    <table class="table table-bordered table-sm table-sm">
      <thead>
        <tr class="text-center">
          <th>No</th>
          <th>
            Kode Prodi
          </th>
          <th>
            Nama
          </th>
          <th>
            Fakultas
          </th>
          <th>Aksi</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(data, index) in prodi" :key="data.id" class="text-center">
          <td>{{ index + 1 }}</td>
          <td>
            {{ data.kode }}
          </td>
          <td>
            {{ data.nama }}
          </td>
          <td>
            {{ data.fakultas.nama }}
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
      prodi: [
        {
          nama: '',
          kode: '',
          fakultas:
          {
            nama: ''
          }
        }
      ]
    }
  },
  mounted () {
    this.prodi = this.fetchProdi()
  },
  methods: {
    fetchProdi () {
      fetch(process.env.gql, {
        method: 'post',
        headers: {
          Authorization: `Bearer ${this.$cookies.get('token')}`,
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'x-hasura-role': this.$cookies.get('role')
        },
        body: JSON.stringify({
          query: `query getProdi {
                    master_prodi {
                      id
                      nama
                      kode
                      fakultas {
                        nama
                      }
                    }
                  }`
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.prodi = gql.data.master_prodi
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    }
  }
}
</script>
