<template>
  <div id="app">
    <img class="logo" src="https://www.baidu.com/img/bd_logo1.png" alt="logo" />

    <HelloWorld />
  </div>
</template>

<script>
import HelloWorld from './components/HelloWorld';

export default {
  name: 'App',
  components: {
    HelloWorld
  }
}
</script>

<style>
.logo {
  width: 100px;
  height: 100px;
}
</style>
