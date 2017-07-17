<template>
  <div class="ui fluid card" v-bind:class="{ 'green': app.alive, 'red': !app.alive }">
    <div class="content">
      <div class="header">{{app.app_name}}</div>
      <div class="meta" v-if="app.alive">
        <a>Alive</a>
        <i class="thumbs up icon green"></i>
      </div>
      <div class="meta" v-if="!app.alive">
        <a>Down</a>
        <i class="thumbs down icon red"></i>
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
