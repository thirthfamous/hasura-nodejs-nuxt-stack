<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h2 class="text-center">
        Jenis Pembayaran
      </h2>
      <a style="margin: 7px;" class="btn btn-success pull-right" @click="tambah = !tambah"><i class="fas fa-plus-square" /> Tambah Jenis Pembayaran</a>
      <div v-if="tambah" class="col-md-6 filter">
        <h5>Tambah Data :</h5>
        <form @submit.prevent="tamabahJenis">
          <b-row class="form-group">
            <b-col sm="3">
              <label>Nama :</label>
            </b-col>
            <b-col sm="7">
              <b-form-input v-model="nama" type="text" />
            </b-col>
          </b-row>
          <button type="submit" class="btn btn-sm btn-success">
            Tambah
          </button>
        </form>
      </div>
      <table class="table table-bordered table-sm table-sm">
        <thead>
          <tr class="text-center">
            <th>No</th>
            <th>
              Nama Jenis Pembayaran
            </th>
            <th>Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(data, index) in jenis_pembayaran" :key="data.id" class="text-center">
            <td>{{ index + 1 }}</td>
            <td>
              {{ data.nama }}
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
      jenis_pembayaran: [{
        id: '',
        nama: ''
      }],
      tambah: false,
      nama: ''
    }
  },
  mounted () {
    this.fetchJenisPembayaran()
  },
  methods: {
    fetchJenisPembayaran () {
      const query = `query getJenisPembayaran {
                      keuangan_jenis_pembayaran {
                        id
                        nama
                      }
                    }`
      fetch(process.env.gql, {
        method: 'post',
        headers: {
          Authorization: `Bearer ${this.$cookies.get('token')}`,
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'x-hasura-role': this.$cookies.get('role')
        },
        body: JSON.stringify({
          query
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error'); return }
          this.jenis_pembayaran = gql.data.keuangan_jenis_pembayaran
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
