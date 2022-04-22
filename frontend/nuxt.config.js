export default {
  // Disable server-side rendering: https://go.nuxtjs.dev/ssr-mode
  ssr: true,
  target: 'server',
  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    title: 'sistem-informasi-imwi',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ]
  },
  server: {
    port: 3001
  },
  env: {
    url: process.env.url || 'http://localhost:8089',
    gql: process.env.gql || 'http://localhost:8080/v1/graphql'
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [
    '@/assets/css/font-face.css',
    '@/assets/vendor/font-awesome-4.7/css/font-awesome.min.css',
    '@/assets/vendor/font-awesome-5/css/fontawesome-all.min.css',
    '@/assets/vendor/mdi-font/css/material-design-iconic-font.min.css',
    '@/assets/vendor/animsition/animsition.min.css',
    '@/assets/vendor/bootstrap-progressbar/bootstrap-progressbar-3.3.4.min.css',
    '@/assets/vendor/wow/animate.css',
    '@/assets/vendor/css-hamburgers/hamburgers.min.css',
    '@/assets/vendor/slick/slick.css',
    '@/assets/vendor/select2/select2.min.css',
    '@/assets/vendor/perfect-scrollbar/perfect-scrollbar.css',
    '@/assets/css/theme.css',
    'vue-select/dist/vue-select.css'
  ],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [
    '~/plugins/vue-select2.js'
  ],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    // https://go.nuxtjs.dev/eslint
    '@nuxtjs/eslint-module',
    '@nuxtjs/moment'
  ],
  moment: {
    defaultTimezone: 'Asia/Jakarta',
    locales: ['id']
  },

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    // https://go.nuxtjs.dev/bootstrap
    'bootstrap-vue/nuxt',
    // https://go.nuxtjs.dev/axios
    '@nuxtjs/axios',
    // https://go.nuxtjs.dev/pwa
    '@nuxtjs/pwa',
    '@nuxtjs/auth-next',
    'cookie-universal-nuxt'
  ],

  apollo: {
    clientConfigs: {
      default: {
        httpEndpoint: process.env.gql
      }
    }
  },

  // PWA module configuration: https://go.nuxtjs.dev/pwa
  pwa: {
    manifest: {
      lang: 'en'
    }
  },
  watchers: {
    webpack: {
      poll: 1000,
      ignored: '/node_modules/'
    }
  },

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
    extend(config, ctx) {
      if (ctx.isDev) {
        config.devtool = ctx.isClient ? 'source-map' : 'inline-source-map'
      }
    }
  }
}
