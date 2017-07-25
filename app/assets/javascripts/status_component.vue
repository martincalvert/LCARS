//= require status_card_component
//= require status_pie_card_component
<template>
  <div class="ui container">
    <div class="ui divider horizontal"></div>
    <h1>Current Statuses</h1>
    <div class="ui active modal" v-if="loading">
      <div class="ui active inverted dimmer">
        <div class="ui text loader">Loading</div>
      </div>
    </div>
    <div class="ui row">
      <button class="ui icon button" v-on:click="toggleChart('pie')">
        <i class="pie chart icon"></i>
      </button>
      <button class="ui icon button" v-on:click="toggleChart('list')">
        <i class="unordered list icon"></i>
      </button>
    </div>
    <div v-for="(apps, environment) in allApps" :key="apps.length" v-bind:class="{ 'blurred_items': loading }" v-if="display_type == 'list'">
      <div class="ui horizontal divider"></div>
      <h2>{{ environment }}</h2>
      <div class="ui six cards" >
        <card v-for="app in apps" :app="app" :key="app.app_name"></card>
      </div>
    </div>
    <div v-if="display_type == 'pie'">
      <div class="ui horizontal divider"></div>
      <div class="ui six cards">
        <pie v-for="(apps, environment) in allApps" :apps="apps" :environment="environment"></pie>
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
        display_type: 'list'
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
    },
    methods: {
      loadStatuses: function(env){
        this.$http.get('/api/v1/statuses/' + env)
                  .then(response => response.json())
                  .then(json => {
                    this.$set(this.allApps, env, json.statuses);
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
