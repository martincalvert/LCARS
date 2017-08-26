<template>
  <div class="ui grid">
    <div class="ui divider horizontal"></div>
    <div class="row">
      <div class="eight wide column centered">
        <div class="row single line">
          <h1>
            Settings
          </h1>
        </div>
        <form class="ui form">
          <div class="field">
            <label>Name</label>
            <input type="text" placeholder="Name" v-model="name">
          </div>
          <div class="field">
            <label>Environments <i class="plus icon" v-on:click="addEnv"></i></label>
            <div v-if="environments">
              <div v-for="n in environments.length" :key="environments.length">
                <input type="url" v-model="environments[n-1]" v-on:blur="updateModel(n-1, $event)">
              </div>
            </div>
          </div>
          <div class="field">
            <label>Check Duration</label>
            <input type="number" v-model="check_duration">
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
      }
    },
    methods: {
      addEnv() {
        let envs = Array.from(this.environments);
        envs.push('')
        this.environments = envs
      },
      updateModel(index, event) {
        if (event.target.value.length > 0) {
          let envs = Array.from(this.environments);
          envs[index] = event.target.value
          this.environments = envs
        }
      },
      ...Vuex.mapActions([
        'saveSettings'
      ])
    },
    computed: {
      ...Vuex.mapGetters([
        'formSettings',
        'statusMessage'
      ]),
      name: {
        get () {
          return this.formSettings.name
        },
        set (value) {
          this.$store.commit('setFormSettingsField', { field: 'name', value: value })
        }
      },
      environments: {
        get () {
          return this.formSettings.environments
        },
        set (value) {
          this.$store.commit('setFormSettingsField', { field: 'environments', value: value })
        }
      },
      check_duration: {
        get () {
          return this.formSettings.check_duration
        },
        set (value) {
          this.$store.commit('setFormSettingsField', { field: 'check_duration', value: value })
        }
      }
    }
  }
</script>
