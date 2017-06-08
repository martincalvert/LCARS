<template>
  <div class="ui grid">
    <div class="row">
      <div class="twelve wide column centered">
        <div class="row single line">
          <h1>
            Apps
            <div class="ui right floated small primary labeled icon button" v-on:click="addApp">
              <i class="add circle icon"></i> Add App
            </div>
          </h1>
        </div>
        <table class="ui padded table">
          <thead class="full-width">
            <tr>
              <th class="single line">Name</th>
              <th>URIs</th>
              <th>Response Code</th>
              <th>Response Format</th>
              <th>Response Body</th>
            </tr>
          </thead>
          <tbody>
            <appRow v-for="app in apps" :app="app"></appRow>
          </tbody>
        </table>
      </div>
    </div>
    <appModal v-on:saved="updateApps"></appModal>
  </div>
</template>

<script>
  var appRow = VComponents['app_component']
  var appModal = VComponents['app_modal_component']
  module.exports = {
    name: 'apps',
    data: function(){
      return {
        apps: [],
        loading: false
      }
    }, created: function() {
      this.loadApps()
    }, methods: {
      loadApps: function() {
        this.$http.get('/api/v1/apps').then((response) => {
          this.apps = response.body.apps
          this.loading = false
        }, (response) => {
          this.error = 'Failed to load profile'
        })
      },
      addApp: function() {
        $('.ui.modal').modal('show');
      },
      updateApps: function(app) {
        let t = JSON.parse(app)
        this.apps.push(t)
      }
    },
    components: {
      'appRow': appRow,
      'appModal': appModal
    }
  }
</script>
