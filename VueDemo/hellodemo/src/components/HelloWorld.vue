<template>
  <div class="hello">
    <p class="type">{{ msg }}</p>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data () {
    return {
      msg: 'Welcome to Your Vue.js App'
    }
  }
}
</script>

<style scoped>
.type {
  color: red;
}
</style>
