<template>
  <div class="subscribe-form" @keyup.enter="$emit('confirm')">
    <div class="blank"></div>
    <div class="input-wrap">
      <input :value="value" placeholder="Enter your email" @input="$emit('input', $event.target.value)" />
    </div>
    <el-button class="btn-submit-search" @click="$emit('confirm')">
      <svg-icon
        icon="icon-arrow"
        height="25"
        width="20"
        dir="left"
      />
      <span>
        Confirm
      </span>
    </el-button>
  </div>
</template>

<script>
export default {
  name: 'SubscribeForm',

  props: {
    value: {
      type: String,
      default: ''
    },
    q: {
      type: String,
      default: ''
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../../assets/_variables.scss';

.subscribe-form {
  margin-top: 7px;
  display: flex;
  width: 100%;
}
.blank{
  width:30cm
}
.input-wrap {
  display: flex;
  position: right;
  width: 20%;
  border: .05rem solid black;
  border-radius: .2rem;
  margin: 0 .9rem;
}
input {
  background: #fff;
  border-radius: .2rem;
  box-sizing: border-box;
  border: none;
  color: #909399;
  flex: 1;
  font-size: 0.875rem;
  outline: none;
  margin: 0;
  padding: 0.5rem 2.25rem 0.5rem 0.8125rem;
  &:focus {
    border-color: $median;
  }
  &::-ms-clear {
    display: none;
  }
}
.btn-clear-search {
  background: none;
  border: none;
  cursor: pointer;
  height: 100%;
  outline: none;
  margin: 0;
  position: absolute;
  right: 0;
  top: 0;
  &:hover,
  &:active {
    opacity: 0.75;
  }
}
.btn-submit-search {
  background: $median;
  color: white;
  border: 1px solid $median;
  border-radius: 4px;
  cursor: pointer;
  width: 7.5rem;
  height: 2.5rem;
  padding: 0 1.5rem;
  @media screen and (max-width: 28rem) {
    padding: 0 .5rem;
    span {
      display: none;
    }
  }
}
.clear-search {
  background-color: transparent;
  display: inline-block;
  border: none;
  width: fit-content;
  color: $cochlear;
  font-size: 1rem;
  font-family: $font-family;
}
</style>
