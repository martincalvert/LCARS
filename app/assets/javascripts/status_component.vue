//= require status_card_component
<template>
  <div class="ui container">
    <div class="ui divider horizontal"></div>
    <h1>Current Statuses</h1>
    <div class="ui active modal" v-if="loading">
      <div class="ui active inverted dimmer">
        <div class="ui text loader">Loading</div>
      </div>
    </div>
    <div v-for="app in apps" :key="app.statuses" v-bind:class="{ 'blurred_items': loading }">
      <div class="ui horizontal divider"></div>
      <h2>{{ app.env }}</h2>
      <div class="ui four cards" >
        <card v-for="status in app.statuses" :app="status" :key="status.app_name"></card>
      </div>
    </div>
  </div>
</template>

<script>
  var card = VComponents['status_card_component']
  module.exports = {
    name: 'status',
    data: function(){
      return {
        apps: [],
        loading: true,
        status_message: null
      }
    },
    created: function(){
      this.loadStatuses();
    },
    methods: {
      loadStatuses: function(){
        this.$http.get('/api/v1/statuses/')
                  .then(response => response.json())
                  .then(json => {
                    this.apps = json.statuses;
                    this.loading = false;
                  });
        }
    },
    components: {
      'card': card
    }
  }
</script>
