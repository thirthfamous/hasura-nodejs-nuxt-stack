<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <h2 class="text-center">
        Silahkan Pilih Kelas :
      </h2>
      <br>
      <div class="text-center">
        <button @click="redirectToSettingPembayaranOther(1)" type="button" class="btn btn-labeled btn-success btn-lg text-center">
          <span class="btn-label"><i class="fa fa-user"></i></span><br> Reguler
        </button>
      </div>
      <div class="text-center">
        <button @click="redirectToSettingPembayaranOther(2)" type="button" class="btn btn-labeled btn-primary btn-lg text-center">
          <span class="btn-label"><i class="fa fa-user"></i></span><br> Karyawan
        </button>
      </div>
    </div>
  </div>
</template>
<script>

export default {
  data () {
    return {
    }
  },
  methods: {
    redirectToSettingPembayaranOther (isKaryawan) {
      this.$router.push({ path: `/setting-pembayaran-misc/${this.$route.params.id_angkatan}/${this.$route.params.id_jurusan}/${isKaryawan}` })
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
  .btn-labeled {
    width: 150px;
    margin: 10px 0;
  }
</style>
