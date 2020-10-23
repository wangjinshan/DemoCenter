<template>
  <div class="hello">
    <input type="text" v-model="name" />

    <p>{{ name }}</p>
    <p>{{ msg.toUpperCase() }}</p>
    <img :src="image" />

    <div class="defalut-s" @click="showMessage">
      click me!!!
      <span @click.stop="testAction">span click</span>
    </div>
  </div>
</template>

<script>
export default {
  name: '',
  props: {
    msg: String,
    name: String,
    html: String,
    image: String,
    proNickname: {
      type: String,
      default: '默认值'
    },
    arr: [String]
  },
  data() {
    return {
      nickname: '',
      address: ''
    }
  },
  watch: {
    nickname: {
      handler(val) {
        this.address = val + 'address'
      },
      immediate: true,
      deep: true
    }
  },
  computed: {
    getAllMsg() {
      return this.nickname + '-' + this.proNickname + '-' + this.address
    }
  },
  methods: {
    testAction() {
      window.console.log(this.nickname, this.proNickname, this.address)
    },
    showMessage() {
      alert(this.getAllMsg)
    }
  },
  mounted() {
    this.nickname = this.proNickname + 'll'
  }
}
</script>

<style lang="scss" scoped>
.defalut-s {
  color: green;
  border: 1px solid green;
  background-color: lightness($color: #000000);
  border-radius: 5px;

  span {
    color: magenta;
  }
}
</style>
