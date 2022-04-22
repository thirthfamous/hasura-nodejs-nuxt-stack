<template>
  <div>
    <header class="header-desktop">
      <div class="section__content section__content--p30">
        <div class="container-fluid">
          <div class="header-wrap">
            <div class="form-header" />
            <div class="header-button">
              <div class="account-wrap">
                <div class="account-item clearfix js-item-menu">
                  <div class="image">
                    <img src="@/assets/images/icon/avatar-01.jpg" alt="John Doe">
                  </div>
                  <div class="content">
                    {{ fullname }}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>
  </div>
</template>

<script>
export default {
  data () {
    return {
      fullname: ''
    }
  },
  mounted () {
    this.assignFullName()
  },
  methods: {
    assignFullName () {
      this.fullname = this.$cookies.get('user').name
    }
  }
}
</script>
