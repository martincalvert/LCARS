//= require dropdown_component
<template>
  <div class="ui modal">
    <i class="close icon"></i>
    <div class="header">
      App: {{ app.name }}
    </div>
    <div class="row" v-if="status_message">
      <div class="six wide column centered">
        <div class="ui green segment raised">{{status_message}}</div>
      </div>
    </div>
    <div class="image content">
      <div class="description">
        <form class="ui form">
          <div class="field">
            <label>Name</label>
            <input type="text" placeholder="App Name" v-model="app.name" name="name">
          </div>
          <div class="field">
            <label>URI</label>
            <input type="url" v-model="app.uri" name="uri">
          </div>
          <div class="field">
            <label>Expected Response Code</label>
            <input type="number" v-model="app.expected_response_code" name="code">
          </div>
          <div class="field">
            <label>Expected Response Format</label>
            <dropdown :items="['xml', 'json']" v-model="app.expected_response_format" default-text="Select Environment"></dropdown>
          </div>
          <div class="field">
            <label>Environment</label>
            <dropdown :items="environments" v-model="app.environment" default-text="Select Environment"></dropdown>
          </div>
          <div class="field">
            <label>Expected Response Body</label>
            <input type="text" v-model="app.expected_response_body">
          </div>
          <div class="inline field">
            <div class="ui toggle checkbox" v-on:click="enabler">
              <input type="checkbox" tabindex="0">
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
      return {
        app: {
          name: null,
          uri: null,
          expected_response_code: 200,
          expected_response_format: null,
          expected_response_body: null,
          enabled: false,
          environment: null,
          _id: null
        },
        loading: true,
        status_message: null
      }
    },
    props: ["passedApp", "environments"],
    mounted: function() {
      let v = this;
      $(".ui.checkbox").checkbox();
      $(".ui.modal").modal({
        onHide: function(){
          let t = v;
          t.$emit("cancel");
        }
      });
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
          },
          uri: {
            identifier  : 'uri',
            rules: [
              {
                type   : 'url',
                prompt : 'Please enter a valid URL'
              }
            ]
          }
        }
      })
    },
    activated: function() {
      if (this.passedApp !== null) {
        this.app._id = this.passedApp._id;
        this.app.name = this.passedApp.name;
        this.app.uri = this.passedApp.uri;
        this.app.expected_response_code = this.passedApp.expected_response_code;
        this.app.expected_response_body = this.passedApp.expected_response_body;
        this.app.expected_response_format = this.passedApp.expected_response_format;
        this.app.enabled = this.passedApp.enabled;
        this.app.environment = this.passedApp.environment;
        if (this.app.enabled) {
          $(".ui.checkbox").checkbox("set checked");
        } else {
          $(".ui.checkbox").checkbox("set unchecked");
        }
      } else {
        this.appReset();
      }
      $(".ui.modal").modal("show");
    },
    methods: {
      enabler: function() {
        this.app.enabled = !this.app.enabled;
      },
      saveApp: function() {
        let token = document.head.querySelector("[name=csrf-token]").content;
        if (!$(".ui.form").form("is valid")){
          this.status_message = "App is not valid, please check the URI and Response Code"
          return
        }
        this.$http.post("api/v1/apps", {"authenticity_token": token, "app": this.app}).then((response) => {
          if(response.body.saved){
            $(".ui.modal").modal("hide");
            this.$emit('saved', response.body.app);
          } else {
            this.status_message = 'Failure saving'
          }
        }, (response) => {
          // FAILURE
          this.status_message = 'Post fail'
        })
      },
      setEnv: function(env){
        this.app.environment = env;
      },
      setFormat: function(format){
        this.app.expected_response_format = format;
      },
      appReset: function() {
        this.app.name = null;
        this.app.uri = null;
        this.app.expected_response_code = 200;
        this.app.expected_response_format = null;
        this.app.expected_response_body = null;
      },
      cancelApp: function() {
        this.appReset();
        $(".ui.modal").modal("hide");
      }
    },
    components: {
      'dropdown': dropdown
    }
  }
</script>
