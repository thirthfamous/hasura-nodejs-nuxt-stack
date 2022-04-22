<template>
  <div>
    <div class="row">
      <div class="col-md-12 bg-white">
        <h2 class="text-center">
          LAPORAN ANALISIS AGING PIUTANG
        </h2>
        <div class="col-md-5 filter">
          <h5>Filter :</h5>
          <form @submit.prevent="processFilter">
            <b-row class="form-group">
              <b-col sm="4">
                <label>Angkatan :</label>
              </b-col>
              <b-col sm="6">
                <b-form-select v-model="id_angkatan" size="sm">
                  <b-form-select-option v-for="data in angkatan" :key="data.id" :value="data.id">
                    {{ data.name }}
                  </b-form-select-option>
                </b-form-select>
              </b-col>
            </b-row>
            <b-row class="form-group">
              <b-col sm="4">
                <label>Jurusan :</label>
              </b-col>
              <b-col sm="6">
                <b-form-select v-model="id_jurusan" size="sm">
                  <b-form-select-option v-for="data in master_prodi" :key="data.id" :value="data.id">
                    {{ data.nama }}
                  </b-form-select-option>
                </b-form-select>
              </b-col>
            </b-row>
            <b-row class="form-group">
              <b-col sm="4">
                <label>NIM :</label>
              </b-col>
              <b-col sm="6">
                <b-form-input v-model="nim" size="sm" type="text" />
              </b-col>
            </b-row>
            <button type="submit" class="btn btn-sm btn-success">
              Process
            </button>
          </form>
        </div>
      </div>
    </div>
    <br>
    <div v-if="mahasiswa_piutang[0]">
      <!-- eslint-disable vue/no-use-v-if-with-v-for,vue/no-confusing-v-for-v-if -->
      <div v-for="data in mahasiswa_piutang" v-if="(nim === data.mahasiswa.nim) || (nim === '')" :key="data.id" class="row" style="margin-bottom:20px;">
        <div class="col-md-12 bg-white">
          <div class="col-md-12">
            <table class="table identity">
              <tr>
                <td>Nama</td>
                <td>:</td>
                <td>{{ data.mahasiswa.nama }}</td>
                <td>Kelas</td>
                <td>:</td>
                <td>
                  {{ (data.mahasiswa.kelas_mahasiswa !== null) ? data.mahasiswa.kelas_mahasiswa.kode : 'Belum ada' }}
                  ({{ (data.mahasiswa.is_karyawan !== null) ? (data.mahasiswa.is_karyawan) ? 'Karyawan' : 'Reguler' : 'Belum ada' }})
                </td>
              </tr>
              <tr>
                <td>NIM</td>
                <td>:</td>
                <td>{{ data.mahasiswa.nim }}</td>
                <td>Angkatan</td>
                <td>:</td>
                <td>{{ (data.mahasiswa.angkatan !== null) ? data.mahasiswa.angkatan.name : 'Angkatan belum ditentukan' }}</td>
              </tr>
              <tr>
                <td>Jurusan</td>
                <td>:</td>
                <td>{{ (data.mahasiswa.prodi !== null) ? data.mahasiswa.prodi.nama : 'Prodi belum ditentukan' }}</td>
              </tr>
              <tr>
                <td>Biaya SPP</td>
                <td>:</td>
                <td>{{ formatRupiah(data.mahasiswa.biaya.biaya_spp, 'Rp. ') }} </td>
              </tr>
              <tr>
                <td>Biaya DPP</td>
                <td>:</td>
                <td>{{ formatRupiah(data.mahasiswa.biaya.biaya_dpp, 'Rp. ') }}</td>
              </tr>
            </table>
            <br>
          </div>
          <div class="table-responsive">
            <table class="table table-bordered table-sm">
              <thead>
                <tr class="text-center">
                  <td rowspan="2">
                    Pembayaran
                  </td>
                  <td rowspan="2">
                    Tanggal Jatuh Tempo
                  </td>
                  <td rowspan="2">
                    Jumlah
                  </td>
                  <td rowspan="2">
                    Umur Piutang
                  </td>
                  <td colspan="5">
                    Lewat Waktu (hari)
                  </td>
                </tr>
                <tr class="text-center">
                  <td>1-30 Hari</td>
                  <td>31-60 Hari</td>
                  <td>61-90 Hari</td>
                  <td>91-120 Hari</td>
                  <td>>= 121</td>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(rinc) in data.piutang" :key="rinc.id" class="text-center">
                  <td>{{ rinc.keterangan }}</td>
                  <td>
                    {{ $moment(rinc.tanggal).format('DD-MM-YYYY') }}
                  </td>
                  <td>
                    {{ formatRupiah(rinc.jumlah_pembayaran, 'Rp. ') }}
                  </td>
                  <td>
                    {{ rinc.umur_piutang }}
                  </td>
                  <td>
                    {{ ((($moment().valueOf() - $moment(rinc.tanggal).valueOf()) &gt; $moment().add(1, 'days').valueOf() - $moment().valueOf()) && (($moment().valueOf() - $moment(rinc.tanggal).valueOf()) &lt; $moment().add(30, 'days').valueOf() - $moment().valueOf()) ) ? formatRupiah(rinc.jumlah_pembayaran, 'Rp. ') : '' }}
                  </td>
                  <td>
                    {{ (($moment().valueOf() - $moment(rinc.tanggal).valueOf()) &gt; $moment().add(31, 'days').valueOf() - $moment().valueOf()) && (($moment().valueOf() - $moment(rinc.tanggal).valueOf()) &lt; $moment().add(60, 'days').valueOf() - $moment().valueOf()) ? formatRupiah(rinc.jumlah_pembayaran, 'Rp. ') : '' }}
                  </td>
                  <td>
                    {{ (($moment().valueOf() - $moment(rinc.tanggal).valueOf()) &gt; $moment().add(61, 'days').valueOf() - $moment().valueOf()) && (($moment().valueOf() - $moment(rinc.tanggal).valueOf()) &lt; $moment().add(90, 'days').valueOf() - $moment().valueOf()) ? formatRupiah(rinc.jumlah_pembayaran, 'Rp. ') : '' }}
                  </td>
                  <td>
                    {{ (($moment().valueOf() - $moment(rinc.tanggal).valueOf()) &gt; $moment().add(91, 'days').valueOf() - $moment().valueOf()) && (($moment().valueOf() - $moment(rinc.tanggal).valueOf()) &lt; $moment().add(121, 'days').valueOf() - $moment().valueOf()) ? formatRupiah(rinc.jumlah_pembayaran, 'Rp. ') : '' }}
                  </td>
                  <td>
                    {{ (($moment().valueOf() - $moment(rinc.tanggal).valueOf()) &gt; $moment().add(121, 'days').valueOf() - $moment().valueOf() ) ? formatRupiah(rinc.jumlah_pembayaran, 'Rp. ') : '' }}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  data () {
    return {
      mahasiswa: [
        {
          angkatan: {
            name: 0
          },
          kelas_mahasiswa: {
            kode: ''
          },
          prodi: {
            nama: ''
          },
          biaya: {
            biaya_dpp: 0,
            biaya_spp: 0,
            is_karyawan: false
          },
          nim: 0,
          nama: '',
          is_karyawan: false,
          id: 0,
          keuangan_pembayaran_mahasiswas: [
            {
              rincian: [
                {
                  waktu_pembayaran: '',
                  nama_pembayaran: '',
                  jumlah_pembayaran: 0,
                  is_lunas: true,
                  keuangan_pembayaran_mahasiswa_kwitansis: [
                    {
                      id: 0
                    }
                  ]
                }
              ]
            }
          ]
        }
      ],
      id_angkatan: 0,
      id_jurusan: 0,
      angkatan: [{
        id: 0,
        name: ''
      }],
      master_prodi: [{
        id: 0,
        nama: ''
      }],
      mahasiswa_piutang: [],
      nim: ''
    }
  },
  created () {
    this.fetchDataForFilter()
    this.mahasiswa = []
  },
  methods: {
    resetFilter () {
      this.nim = null
      this.processFilter()
    },
    formatRupiah (angka, prefix) {
      const number_string = angka.toString().replace(/[^,\d]/g, '')
      const split = number_string.split(',')
      const sisa = split[0].length % 3
      let rupiah = split[0].substr(0, sisa)
      const ribuan = split[0].substr(sisa).match(/\d{3}/gi)

      // tambahkan titik jika yang di input sudah menjadi angka ribuan
      if (ribuan) {
        const separator = sisa ? '.' : ''
        rupiah += separator + ribuan.join('.')
      }

      rupiah = split[1] !== undefined ? rupiah + ',' + split[1] : rupiah
      return prefix === undefined ? rupiah : (rupiah ? 'Rp. ' + rupiah : '')
    },
    processFilter () {
      if (this.nim === null) { alert('Harap mengisi form NIM'); return }
      this.offset = 0
      this.fetchKeuanganRincian()
    },
    fetchDataForFilter () {
      const query = `query getDataForFilter {
                      angkatan(order_by: {name: asc}) {
                          id
                          name
                        }
                        master_prodi {
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
          this.angkatan = gql.data.angkatan
          this.master_prodi = gql.data.master_prodi
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    },
    fetchKeuanganRincian () {
      if (this.id_angkatan === 0 || this.id_jurusan === 0) {
        alert('Harap mengisi filter dengan benar')
        return
      }
      const query = `query getLaporanPiutangPerAngkatanAndOrJurusan($id_angkatan: Int!, $id_jurusan: uuid!, $waktu_pembayaran: date!) {
        mahasiswa(where: {
          id_angkatan: {_eq: $id_angkatan},
          kode_jurusan: {_eq: $id_jurusan},
          keuangan_pembayaran_mahasiswas: {
            rincian: {
              is_lunas: {_eq: false},
              waktu_pembayaran: {_lt: $waktu_pembayaran}
            }
          }
        }) {
          angkatan {
            name
          }
          kelas_mahasiswa {
            kode
          }
          prodi {
            nama
          }
          biaya {
            biaya_dpp
            biaya_spp
            is_karyawan
          }
          nim
          nama
          is_karyawan
          id
          keuangan_pembayaran_mahasiswas {
            rincian(order_by: {id: asc}, where: {is_lunas: {_eq: false}, waktu_pembayaran: {_lt: $waktu_pembayaran}}) {
              waktu_pembayaran
              nama_pembayaran
              jumlah_pembayaran
              is_lunas
              keuangan_pembayaran_mahasiswa_kwitansis {
                id
              }
            }
          }
        }
      }
      `
      const id_jurusan = this.id_jurusan
      const id_angkatan = this.id_angkatan
      const waktu_pembayaran = this.$moment()
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
          variables: { id_jurusan, id_angkatan, waktu_pembayaran }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.data.mahasiswa[0] === undefined) { alert('Mahasiswa tidak ditemukan'); return }
          if (gql.error) { alert('Error 403 Server Error'); return }
          this.mahasiswa = gql.data.mahasiswa
          this.processRincian()
        }).catch((error) => {
          this.errorMessage = error
          console.error('There was an error!', error)
        })
    },
    processRincian () {
      const mahasiswa_piutang = []
      this.mahasiswa.forEach((mhs) => {
        const table = []
        mhs.keuangan_pembayaran_mahasiswas[0].rincian.forEach((data) => {
          table.push({
            tanggal: data.waktu_pembayaran,
            keterangan: data.nama_pembayaran,
            jumlah_pembayaran: data.jumlah_pembayaran,
            umur_piutang: this.$moment(data.waktu_pembayaran).fromNow()
          })
        })
        mahasiswa_piutang.push({
          mahasiswa: mhs,
          piutang: table
        })
      })
      this.mahasiswa_piutang = mahasiswa_piutang
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
  .identity {
    background-color:#e4e6d7; padding: 20px 10px;
  }
  td {
    white-space:nowrap;
  }
</style>
