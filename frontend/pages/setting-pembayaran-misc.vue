<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <nuxt-child />
    </div>
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
      this.angkatan_name = name
      alert(name)
      alert(this.angkatan_name)
      this.$router.push({ path: `/setting-pembayaran-misc/${id}` })
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
