<template>
  <div class="ui grid">
    <div class="ui divider horizontal"></div>
    <div class="ui active modal" v-if="loading">
      <div class="ui active inverted dimmer">
        <div class="ui text loader">Loading</div>
      </div>
    </div>
    <div class="row" v-if="status_message">
      <div class="six wide column centered">
        <div class="ui green segment raised">{{status_message}}</div>
      </div>
    </div>
    <div class="row" v-bind:class="{ 'blurred_items': loading }">
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
              <th>Environment</th>
              <th>Enabled</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <appRow v-for="app in apps" :app="app" :key="app._id" v-on:edit="setPassed" v-on:delete="deleteApp"></appRow>
          </tbody>
        </table>
      </div>
    </div>
    <keep-alive>
      <appModal :passedApp="passedApp" :environments="environments" v-on:cancel="cancel" v-on:saved="updateApps" v-if="showModal"></appModal>
    </keep-alive>
  </div>
</template>

<script>
  var appRow = VComponents["app_component"];
  var appModal = VComponents["app_modal_component"];
  module.exports = {
    name: "apps",
    data: function(){
      return {
        apps: [],
        passedApp: null,
        showModal: false,
        loading: true,
        status_message: null,
        environments: []
      }
    }, created: function() {
      this.loadApps();
      this.fetchEnvironments();
    }, methods: {
      loadApps: function() {
        this.$http.get("/api/v1/apps").then((response) => {
          this.apps = response.body.apps;
          this.loading = false;
        }, (response) => {
          this.status_message = 'Failed to load apps'
        })
      },
      fetchEnvironments: function(){
        this.$http.get('/api/v1/settings')
                  .then(response => response.json())
                  .then(json => {
                    this.environments = json.settings.envs
                  }, (response) => {
                    // FAILURE
                    this.error = "Post fail";
                  })
      },
      cancel: function(){
        this.showModal = false;
        this.passedApp = null;
      },
      addApp: function() {
        this.showModal = true;
      },
      updateApps: function(app) {
        let t = JSON.parse(app);
        let index = this.apps.findIndex(x => x._id.$oid == t._id.$oid)
        if (index > -1){
          this.apps.splice(index, 1, t)
        } else {
          this.apps.push(t);
        }
        this.showModal = false;
      },
      setPassed: function(app) {
        this.passedApp = this.apps.find(x => x._id.$oid == app._id.$oid);
        this.showModal = true;
      },
      deleteApp: function(app) {
        let token = document.head.querySelector("[name=csrf-token]").content;
        Vue.http.headers.common["X-CSRF-Token"] = token;
        this.$http.delete("/api/v1/apps", {"headers": {"X-APP-ID": app._id.$oid}}).then((response) => {
          if(response.body.deleted){
            let index = this.apps.findIndex(x => x._id.$oid == app._id.$oid);
            this.apps.splice(index, 1);
          }
        }, (response) => {
          this.status_message = 'Failed to delete app'
        })
      }
    },
    components: {
      "appRow": appRow,
      "appModal": appModal
    }
  }
</script>
