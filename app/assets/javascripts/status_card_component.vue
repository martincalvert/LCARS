<template>
  <div class="ui nagative card">
    <div class="content">
      <div class="header">{{app.appName}}</div>
      <div class="meta">
        <a>{{app.appStatus}}</a>
        <i class="smile icon red"></i>
      </div>
    </div>
    <div class="extra content">
      <span class="right floated">
        Up since 2013
      </span>
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
