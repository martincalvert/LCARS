<template>
  <div class="ui grid">
    <div class="ui active modal" v-if="loading">
      <div class="ui active inverted dimmer">
        <div class="ui text loader">Loading</div>
      </div>
    </div>
    <div class="row">
      <div class="eight wide column centered">
        <div class="row single line">
          <h1>
            Settings
          </h1>
        </div>
        <div class="row" v-if="status_message">
          <div class="two wide column centered">
            <div class="ui green segment raised">{{status_message}}</div>
          </div>
        </div>
        <form class="ui form">
          <div class="field">
            <label>Name</label>
            <input type="text" placeholder="Name" v-model="settings.name">
          </div>
          <div class="field">
            <label>Environments <i class="plus icon" v-on:click="addEnv"></i></label>
            <div v-for="n in settings.envs.length" :key="settings.envs.id">
              <input type="url" v-model="settings.envs[n-1]">
            </div>
          </div>
          <div class="field">
            <label>Check Duration</label>
            <input type="number" v-model="settings.check_duration">
          </div>
          <div class="actions">
            <div class="ui cancel red right labeled icon button">
              Cancel
              <i class="remove icon"></i>
            </div>
            <div class="ui green right labeled icon button" v-on:click="saveSettings">
              Save
              <i class="checkmark icon"></i>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
  module.exports = {
    name: 'settings',
    data: function(){
      return {
        settings: {
          name: null,
          check_duration: 10,
          envs: []
        },
        loading: true,
        status_message: null
      }
    }, created: function() {
      this.loadSettings()
    }, methods: {
      addEnv: function() {
        this.settings.envs.push('');
      },
      loadSettings: function() {
        this.$http.get('/api/v1/settings').then((response) => {
          this.settings = response.body.settings
          this.loading = false
        }, (response) => {
          this.loading = false
        })
      },
      saveSettings: function() {
        let token = document.head.querySelector("[name=csrf-token]").content;
        this.$http.post('/api/v1/settings', {'authenticity_token': token, 'settings': this.settings}).then((response) => {
          this.status_message = 'Settings Saved'
        }, (response) => {
          this.status_message = 'Failed to save settings'
        })
      }
    },
    components: {
    }
  }
</script>
