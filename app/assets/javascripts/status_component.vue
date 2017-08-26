//= require status_card_component
//= require status_pie_card_component
<template>
  <div class="ui container">
    <div class="ui divider horizontal"></div>
    <div class="ui divider horizontal"></div>
    <div class="ui row">
      <h1 class="ui header">
        <div class="content">Current Statuses</div>
      </h1>
      <button class="ui icon button pink" v-on:click="toggleChart('grid')">
        <i class="grid layout icon"></i>
      </button>
      <button class="ui icon button purple" v-on:click="toggleChart('list')">
        <i class="unordered list icon"></i>
      </button>
      <button class="ui icon button violet" v-on:click="toggleChart('pie')">
        <i class="pie chart icon"></i>
      </button>
    </div>
    <div class="ui horizontal divider"></div>
    <div v-for="(environment_apps, environment) in apps" v-if="display_type == 'list'">
      <h3>{{ environment }}</h3>
      <div class="ui eight cards doubling" >
        <card v-for="app in environment_apps.apps" :app="app" :key="app.app_name"></card>
      </div>
      <div class="ui horizontal divider"></div>
    </div>
    <div v-if="display_type == 'pie'">
      <div class="ui five cards">
        <pie v-for="(environment_apps, environment) in apps" :apps="environment_apps" :key="environment_apps.down" :environment="environment"></pie>
      </div>
    </div>
    <div v-if="display_type == 'grid'">
      <div class="ui eight cards doubling">
        <div v-for="(environment_apps, environment) in apps" class="ui fluid card" v-bind:class="{ 'green': environment_apps.down == 0, 'red': environment_apps.down != 0 }">
          <div class="content">
            <div class="header">
              <h5 class="ui header">
                <i class="icon" v-bind:class="{ 'thumbs up green': environment_apps.down == 0, 'fire red': environment_apps.down != 0 }"></i>
                <div class="content">
                  {{environment}}
                </div>
              </h5>
            </div>
          </div>
        </div>
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
        display_type: 'grid'
      }
    },
    methods: {
      toggleChart: function(type){
        this.display_type = type;
      }
    },
    computed: Vuex.mapGetters([
        'apps',
    ]),
    components: {
      'card': card,
      'pie': pie
    }
  }
</script>
