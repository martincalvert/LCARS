//= require dropdown_component
<template>
  <div class="ui modal" id="appModal">
    <i class="close icon"></i>
    <div class="header">
      App: {{ name }}
    </div>
    <div class="row" v-if="statusMessage">
      <div class="six wide column centered">
        <div class="ui green segment raised">{{statusMessage}}</div>
      </div>
    </div>
    <div class="image content">
      <div class="description">
        <form class="ui form">
          <div class="field">
            <label>Name</label>
            <input type="text" placeholder="App Name" v-model="name" name="name">
          </div>
          <div class="field">
            <label>URI</label>
            <input type="url" v-model="uri" name="uri">
          </div>
          <div class="field">
            <label>Expected Response Code</label>
            <input type="number" v-model="expected_response_code" name="code">
          </div>
          <div class="field">
            <label>Environment</label>
            <dropdown :items="environments" v-model="environment" default-text="Select Environment"></dropdown>
          </div>
          <div class="inline field">
            <div class="ui toggle checkbox" v-on:click="enabler">
              <input type="checkbox" tabindex="0" v-model="enabled">
              <label>Toggle</label>
            </div>
          </div>
        </form>
      </div>
    </div>
    <div class="actions">
      <div class="ui cancel red right labeled icon button">
        Cancel
        <i class="remove icon"></i>
      </div>
      <div class="ui green right labeled icon button" v-on:click="saveApp">
        Save
        <i class="checkmark icon"></i>
      </div>
    </div>
  </div>
</template>

<script>
  var dropdown = VComponents['dropdown_component']
  module.exports = {
    name: "appModal",
    data: function(){
      return {}
    },
    computed: {
      ...Vuex.mapGetters([
        'modalApp',
        'environments',
        'statusMessage'
      ]),
      name: {
        get () {
          return this.modalApp.name
        },
        set (value) {
          this.$store.commit('setModalAppField', { field: 'name', value: value })
        }
      },
      uri: {
        get () {
          return this.modalApp.uri
        },
        set (value) {
          this.$store.commit('setModalAppField', { field: 'uri', value: value })
        }
      },
      expected_response_code: {
        get () {
          return this.modalApp.expected_response_code
        },
        set (value) {
          this.$store.commit('setModalAppField', { field: 'expected_response_code', value: value })
        }
      },
      environment: {
        get () {
          return this.modalApp.environment
        },
        set (value) {
          this.$store.commit('setModalAppField', { field: 'environment', value: value })
        }
      },
      enabled: {
        get () {
          return this.modalApp.enabled
        },
        set (value) {
          this.$store.commit('setModalAppField', { field: 'enabled', value: value })
        }
      }
    },
    mounted: function() {
      $(".ui.form").form({
        on: "blur",
        inline: true,
        fields: {
          code: {
            identifier  : 'code',
            rules: [
              {
                type   : 'integer[100..599]',
                prompt : 'Please enter a valid HTTP response code'
              }
            ]
          }
        }
      })
    },
    methods: {
      enabler: function() {
        this.enabled = !this.enabled
      },
      ...Vuex.mapActions([
        'saveApp'
      ])
    },
    components: {
      'dropdown': dropdown
    }
  }
</script>
