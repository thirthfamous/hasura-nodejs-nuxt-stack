<template>
  <div class="container">
    <div class="login-wrap">
      <div class="login-content">
        <div class="login-logo">
          <a href="#">
            <img src="images/icon/logo.png" alt="CoolAdmin">
          </a>
          <div v-if="errorMessage != ''" class="alert alert-danger" role="alert">
            {{ errorMessage }}
          </div>
        </div>
        <div class="login-form">
          <form method="post" @submit.prevent="signIn">
            <div class="form-group">
              <label>Username</label>
              <input v-model="username" class="au-input au-input--full" type="text" placeholder="Username">
            </div>
            <div class="form-group">
              <label>Password</label>
              <input v-model="password" class="au-input au-input--full" type="password" placeholder="Password">
            </div>
            <button class="au-btn au-btn--block au-btn--green m-b-20" type="submit">
              sign in
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  data () {
    return {
      username: '',
      password: '',
      errorMessage: ''
    }
  },
  mounted () {

  },
  methods: {
    signIn () {
      this.errorMessage = ''
      axios({
        method: 'post',
        url: process.env.url + '/login',
        data: {
          username: this.username,
          password: this.password
        }
      }).then((response) => {
        // assign to cookie memory
        this.$cookies.set('token', response.data.token)
        this.$cookies.set('user', response.data.user)
        this.$cookies.set('roles', response.data.roles)
        this.$router.push({ path: '/' })
      }).catch((error) => {
        if (error.response) {
          this.errorMessage = error.response.data.message
          return
        }
        alert(error)
      })
    }
  }
}
</script>
