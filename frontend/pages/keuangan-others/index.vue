<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h2 class="text-center">
        PEMBAYARAN LAIN MAHASISWA
      </h2>
      <a style="margin: 7px;" class="btn btn-info pull-right" @click="filter = !filter"><i class="fas fa-filter" />Filter</a>
      <div v-if="filter" class="col-md-5 filter">
        <h5>Filter Mahasiswa :</h5>
        <form @submit.prevent="processFilter">
          <b-row class="my-1">
            <b-col sm="2">
              <label>NIM :</label>
            </b-col>
            <b-col sm="7">
              <b-form-input v-model="nim" size="sm" type="text" />
            </b-col>
          </b-row>
          <button type="submit" class="btn btn-sm btn-success">
            Process
          </button>
          <button class="btn btn-sm btn-danger" @click="resetFilter">
            Reset
          </button>
        </form>
      </div>
      <table class="table table-bordered table-sm table-sm">
        <thead>
          <tr class="text-center">
            <th>No</th>
            <th>
              Nama
            </th>
            <th>
              Jurusan
            </th>
            <th>
              NIM
            </th>
            <th>
              Angkatan
            </th>
            <th>Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(data, index) in mahasiswa" :key="data.id" class="text-center">
            <td>{{ (page == 1) ? index + 1 : (page * 10) + index - limit + 1 }}</td>
            <td>
              {{ data.nama }}
            </td>
            <td>
              {{ data.prodi.nama }}
            </td>
            <td>
              {{ data.nim }}
            </td>
            <td>
              {{ data.angkatan.name }}
            </td>
            <td>
              <a class="btn btn-info" @click="detailMahasiswa(data.nim)"> Detail </a>
            </td>
          </tr>
        </tbody>
      </table>
      <b-pagination
        v-model="page"
        class="pull-right"
        :total-rows="total_row"
        :per-page="limit"
        prev-text="Prev"
        next-text="Next"
        @change="handlePageChange"
      />
    </div>
  </div>
</template>
<script>
export default {
  data () {
    return {
      mahasiswa: [
        {
          nama: '',
          email: '',
          nim: '',
          angkatan: {
            nama: ''
          },
          prodi: {
            id: '',
            nama: ''
          }
        }
      ],
      limit: 10,
      offset: 0,
      nim: null,
      id_prodi: null,
      id_angkatan: null,
      total_row: 0,
      page: 1,
      filter: false
    }
  },
  mounted () {
    this.fetchMahasiswa()
  },
  methods: {
    resetFilter () {
      this.nim = null
      this.processFilter()
    },
    detailMahasiswa (nim) {
      this.$router.push({ path: `/keuangan-others/${nim}` })
    },
    handlePageChange (value) {
      this.page = value
      this.offset = (this.page - 1) * this.limit
      this.fetchMahasiswa()
    },
    processFilter () {
      this.offset = 0
      this.fetchMahasiswa()
    },
    fetchMahasiswa () {
      const query = `query getMahasiswa($limit: Int!, $offset: Int!, $nim: String, $id_prodi: uuid, $id_angkatan: Int) {
                        mahasiswa(limit: $limit, offset: $offset, order_by: {id: desc}, where: {nim: {_eq: $nim}, prodi: {id: {_eq: $id_prodi}}, angkatan: {id: {_eq: $id_angkatan}}}) {
                          nama
                          email
                          nim
                          angkatan {
                            name
                          }
                          prodi {
                            nama
                            id
                          }
                        }
                        mahasiswa_aggregate(where: {nim: {_eq: $nim}, prodi: {id: {_eq: $id_prodi}}} ) {
                          aggregate {
                            count
                          }
                        }
                      }`
      const limit = this.limit
      const offset = this.offset
      const nim = (this.nim) ? this.nim : null
      // eslint-disable-next-line camelcase
      const id_prodi = (this.id_prodi) ? this.id_prodi : null
      // eslint-disable-next-line camelcase
      const id_angkatan = (this.id_angkatan) ? this.id_angkatan : null

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
          variables: { limit, offset, nim, id_prodi, id_angkatan }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.mahasiswa = gql.data.mahasiswa
          this.total_row = gql.data.mahasiswa_aggregate.aggregate.count
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
