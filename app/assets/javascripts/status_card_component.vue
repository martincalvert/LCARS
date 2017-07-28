<template>
  <div class="ui fluid card" v-bind:class="{ 'green': app.alive, 'red': !app.alive }">
    <div class="content">
      <div class="header">
        <h5 class="ui header">
          <i class="thumbs icon" v-bind:class="{ 'up green': app.alive, 'down red': !app.alive }"></i>
          <div class="content">
            {{app.app_name}}
          </div>
        </h5>
      </div>
    </div>
  </div>
</template>

<script>
  module.exports = {
    name: 'status_card',
    data: function(){
      return {}
    },
    props: ['app'],
  }
</script>
