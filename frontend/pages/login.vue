<template>
  <div>
    <Login />
  </div>
</template>

<script>
export default {
  layout: 'login',
  middleware: 'anauth'
}
</script>
