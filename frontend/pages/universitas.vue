<template>
  <div class="row">
    <div class="col-md-12 bg-white">
      <b-nav tabs>
        <b-nav-item title="universitas" :active="$route.name == 'universitas-universitas'" to="/universitas/universitas">
          Universitas
        </b-nav-item>
        <b-nav-item title="fakultas" :active="$route.name == 'universitas-fakultas' || $route.name == 'universitas-fakultas-tambah'" to="/universitas/fakultas">
          Fakultas
        </b-nav-item>
        <b-nav-item title="prodi" :active="$route.name == 'universitas-prodi' || $route.name == 'universitas-prodi-tambah'" to="/universitas/prodi">
          Program Studi
        </b-nav-item>
      </b-nav>
      <div class="row" style="margin-top:20px">
        <nuxt-child />
      </div>
    </div>
  </div>
</template>

<style scoped>
  .bg-white {
    padding: 20px;
  }
</style>
