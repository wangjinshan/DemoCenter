<template>
  <div class="test">
    <HelloWorld
      msg="messs"
      name="sdsdsd"
      image="https://www.baidu.com/img/bd_logo1.png"
      :proNickname="proNickname"
    ></HelloWorld>
  </div>
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'

export default {
  name: 'app',
  data() {
    return {
      proNickname: '开始'
    }
  },
  components: {
    HelloWorld
  }
}
</script>
