<template>
  <div class="search-form" @keyup.enter="$emit('search')">
    <div autocomplete="off" class="input-wrap" style="margin-left: 0">
      <!-- <form autocomplete="off" action="/action_page.php"> -->
        <div class="autocomplete" style="width:100%;border: 1px solid #dfe1e5">
          <input style="width:100%;height:38px" :value="value" placeholder="Type here" id="myInput" @input="$emit('input', $event.target.value)" />
          <button v-if="q" class="btn-clear-search" @click="$emit('clear')" style="height:35px">
            <svg-icon
              name="icon-clear"
              stroke="red"
              color="#909399 #fff"
              height="22"
              width="22"
            />
          </button>
          <!-- <input id="myIput" type="text" name="myCountry" placeholder="Country"> -->
        </div>
      <!-- </form> -->

    </div>
    <el-button class="btn-submit-search" @click="$emit('search')">
      <svg-icon
        icon="icon-magnifying-glass"
        height="25"
        width="25"
        dir="left"
      />
      <span>
        Search
      </span>
    </el-button>
  </div>
</template>

<script>
export default {
  name: 'SearchForm',

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

.search-form {
  display: flex;
  width: 100%;
}
.input-wrap {
  display: flex;
  position: relative;
  width: 100%;
  // border: .05rem solid black;
  border: none;
  box-shadow: 0px 0px 10px #d5d5d5;;
  border-radius: .2rem;
  margin: 0 .5rem;

  .autocomplete-items {
    position: absolute;
    padding: 10px;
    border: 1px solid #d4d4d4;
    border-bottom: none;
    border-top: none;
    z-index: 99;
    /*position the autocomplete items to be the same width as the container:*/
    top: 100%;
    left: 0;
    right: 0;
  }
  .autocomplete-items div {
    padding: 10px;
    cursor: pointer;
    background-color: #fff;
    border-bottom: 1px solid #d4d4d4;
  }
  .autocomplete-items div:hover {
    /*when hovering an item:*/
    background-color: #e9e9e9;
  }
  .autocomplete-active {
    /*when navigating through the items using the arrow keys:*/
    background-color: DodgerBlue !important;
    color: #ffffff;
  }
  .autocomplete {
    /*the container must be positioned relative:*/
    position: relative;
    display: inline-block;
  }
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

#myInputautocomplete-list {
  padding: 10px;

}
</style>
