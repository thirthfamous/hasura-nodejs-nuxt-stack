<template>
  <div>
    <!-- MENU SIDEBAR-->
    <aside class="menu-sidebar d-none d-lg-block">
      <div class="logo">
        <a href="#">
          <img src="@/assets/images/icon/logo.png" alt="Cool Admin">
        </a>
      </div>
      <div class="menu-sidebar__content js-scrollbar1">
        <nav class="navbar-sidebar">
          <ul class="list-unstyled navbar__list">
            <div v-for="navigation in navigations" :key="navigation.navigation.id">
              <!-- is parent -->
              <li v-if="navigation.navigation.child.length == 0" class="parent-menu">
                <NuxtLink :to="navigation.navigation.link">
                  <i :class="navigation.navigation.icon" />{{ navigation.navigation.nama }}
                </nuxtlink>
              </li>
              <!-- has child -->
              <li v-else class="parent-menu">
                <a @click="sidebarAction($event)">
                  <i :class="navigation.navigation.icon" />{{ navigation.navigation.nama }}
                </a>
                <ul>
                  <li v-for="child in navigation.navigation.child" :key="child.id" class="child-menu" style="list-style-type: none;">
                    <NuxtLink :to="child.link">
                      <i :class="child.icon" />{{ child.nama }}
                    </nuxtlink>
                  </li>
                </ul>
              </li>
            </div>
            <div>
              <li>
                <a @click="logout">
                  <i class="fas fa-power-off" />Logout
                </a>
              </li>
            </div>
            <div style="bottom:40px; margin-top:40px;">
              <select class="form-control" @change="fetchNav($event)">
                <option v-for="role in roles" :key="role" :value="role.name">
                  {{ role.role_name }}
                </option>
              </select>
            </div>
          </ul>
        </nav>
      </div>
    </aside>
  </div>
  <!-- END MENU SIDEBAR-->
</template>
<script>

export default {
  data () {
    return {
      roles: [],
      login: {
        username: '',
        password: ''
      },
      navigations: [],
      param: ''
    }
  },
  fetch () {
    this.roles = this.$cookies.get('roles')
  },
  mounted () {
    this.firstFetch()
  },
  methods: {
    logout () {
      this.$cookies.removeAll()
      this.$router.push({ path: '/login' })
    },
    sidebarAction (event) {
      const child = event.target.parentElement.querySelectorAll('.child-menu')
      child.forEach((element) => {
        if (element.style.display === 'block') {
          element.style.display = 'none'
        } else {
          element.style.display = 'block'
        }
      })
    },
    fetchNav (event) {
      this.navigations = []
      const name = event.target.value
      const query = `query getNavigationsByIdRole($name: String!) {
                      role_navigation(where: {navigation: {id_parent: {_is_null: true}}, role: {name: {_eq: $name}}}, distinct_on: id) {
                        id
                        navigation {
                          child(order_by: {id: asc}, where: {role_navigations: {role: {name: {_eq: $name}}}}) {
                            icon
                            id
                            id_parent
                            link
                            nama
                          }
                          icon
                          id
                          link
                          nama
                        }
                      }
                    }
`
      fetch(process.env.gql, {
        method: 'post',
        headers: {
          Authorization: `Bearer ${this.$cookies.get('token')}`,
          'Content-Type': 'application/json',
          Accept: 'application/json'
        },
        body: JSON.stringify({
          query,
          variables: { name }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.navigations = gql.data.role_navigation
          console.error(this.navigations)
        }).catch((error) => {
          console.error('There was an error!', error)
        })
      this.$cookies.set('role', name)
    },
    firstFetch () {
      const name = this.$cookies.get('roles')[0].name
      const query = `query getNavigationsByIdRole($name: String!) {
                      role_navigation(where: {navigation: {id_parent: {_is_null: true}}, role: {name: {_eq: $name}}}, distinct_on: id) {
                        id
                        navigation {
                          child(order_by: {id: asc}, where: {role_navigations: {role: {name: {_eq: $name}}}}) {
                            icon
                            id
                            id_parent
                            link
                            nama
                          }
                          icon
                          id
                          link
                          nama
                        }
                      }
                    }
`
      fetch(process.env.gql, {
        method: 'post',
        headers: {
          Authorization: `Bearer ${this.$cookies.get('token')}`,
          'Content-Type': 'application/json',
          Accept: 'application/json'
        },
        body: JSON.stringify({
          query,
          variables: { name }
        })
      })
        .then(res => res.json())
        .then((gql) => {
          if (gql.error) { alert('Error 403 Server Error') }
          this.navigations = gql.data.role_navigation
        }).catch((error) => {
          console.error('There was an error!', error)
        })
      this.$cookies.set('role', name)
    }
  }

}
</script>

<style>
  .child-menu {
    background-color: rgb(250, 248, 246);
    transition: .6s ease opacity,.6s ease transform;
    display: none;
  }

  .child-menu a {
    margin-left: 25px;
  }

  a {
    cursor: pointer;
  }
</style>
