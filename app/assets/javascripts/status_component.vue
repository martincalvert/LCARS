//= require status_card_component
//= require status_pie_card_component
<template>
  <div class="ui container">
    <div class="ui divider horizontal"></div>
    <div class="ui row">
      <h1 class="ui header">
        <div class="content">Current Statuses</div>
      </h1>
      <button class="ui icon button violet" v-on:click="toggleChart('pie')">
        <i class="pie chart icon"></i>
      </button>
      <button class="ui icon button purple" v-on:click="toggleChart('list')">
        <i class="unordered list icon"></i>
      </button>
    </div>
    <div class="ui active modal" v-if="loading">
      <div class="ui active inverted dimmer">
        <div class="ui text loader">Loading</div>
      </div>
    </div>
    <div v-for="(apps, environment) in allApps" :key="apps.length" v-bind:class="{ 'blurred_items': loading }" v-if="display_type == 'list'">
      <div class="ui horizontal divider"></div>
      <h3>{{ environment }}</h3>
      <div class="ui ten cards" >
        <card v-for="app in apps.apps" :app="app" :key="app.app_name"></card>
      </div>
    </div>
    <div v-if="display_type == 'pie'">
      <div class="ui horizontal divider"></div>
      <div class="ui five cards">
        <pie v-for="(apps, environment) in allApps" :apps="apps" :key="apps.down" :environment="environment"></pie>
      </div>
    </div>
  </div>
</template>

<script>
  var card = VComponents['status_card_component']
  var pie = VComponents['status_pie_card_component']
  module.exports = {
    name: 'status',
    data: function(){
      return {
        allApps: {},
        loading: true,
        status_message: null,
        display_type: 'list',
        interval: null,
        environments: []
      }
    },
    created: function(){
      this.$http.get('/api/v1/settings')
                .then(response => response.json())
                .then(json => {
                  this.environments = json.settings.envs;
                  for (var env in this.environments){
                    this.loadStatuses(this.environments[env]);
                  }
                  this.loading = false;
                })

      this.interval = setInterval(function () {
        for (var env in this.environments){
          this.loadStatuses(this.environments[env]);
        }
      }.bind(this), 10000);
    },
    methods: {
      loadStatuses: function(env){
        this.$http.get('/api/v1/statuses/' + env)
                  .then(response => response.json())
                  .then(json => {
                    if (this.allApps.hasOwnProperty(env)){
                      if (this.allApps[env].down != json.statuses.down && this.allApps[env].up != json.statuses.up){
                        this.$set(this.allApps, env, json.statuses);
                      }
                    } else {
                      this.$set(this.allApps, env, json.statuses);
                    }
                  });
      },
      toggleChart: function(type){
        this.display_type = type;
      }
    },
    components: {
      'card': card,
      'pie': pie
    }
  }
</script>
