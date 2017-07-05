<template>
  <div class="ui modal">
    <i class="close icon"></i>
    <div class="header">
      App: {{ app.name }}
    </div>
    <div class="image content">
      <div class="description">
        <form class="ui form">
          <div class="field">
            <label>Name</label>
            <input type="text" placeholder="App Name" v-model="app.name">
          </div>
          <div class="field">
            <label>URIs <i class="plus icon" v-on:click="addUri"></i></label>
            <div v-for="n in app.uris.length" :key="app.uris.id">
              <input type="url" v-model="app.uris[n-1]">
            </div>
          </div>
          <div class="field">
            <label>Expected Response Code</label>
            <input type="number" v-model="app.expected_response_code">
          </div>
          <div class="field">
            <label>Expected Response Format</label>
            <div class="ui selection dropdown">
              <div class="default text">Select</div>
              <i class="dropdown icon"></i>
              <input type="hidden" v-model="app.expected_response_format">
              <div class="menu">
                <div class="item" data-value="json">JSON</div>
                <div class="item" data-value="xml">XML</div>
              </div>
            </div>
          </div>
          <div class="field">
            <label>Expected Response Body</label>
            <input type="text" v-model="app.expected_response_body">
          </div>
          <div class="inline field">
            <div class="ui toggle checkbox">
              <input type="checkbox" tabindex="0" v-on:change="enabler">
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
  module.exports = {
    name: "appModal",
    data: function(){
      return {
        app: {
          name: null,
          uris: [''],
          expected_response_code: 200,
          expected_response_format: "json",
          expected_response_body: null,
          enabled: false,
          _id: null
         }
      }
    },
    props: ["passedApp"],
    mounted: function() {
      let v = this;
      $(".ui.dropdown").dropdown();
      $(".ui.checkbox").checkbox();
      $(".ui.modal").modal({
        onHide: function(){
          let t = v;
          t.$emit("cancel");
        }
      });
    },
    activated: function() {
      if (this.passedApp !== null) {
        this.app._id = this.passedApp._id;
        this.app.name = this.passedApp.name;
        this.app.uris = this.passedApp.uris;
        this.app.expected_response_code = this.passedApp.expected_response_code;
        this.app.expected_response_body = this.passedApp.expected_response_body;
        this.app.expected_response_format = this.passedApp.expected_response_format;
        this.app.enabled = this.passedApp.enabled;
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
        this.$http.post("api/v1/apps", {"authenticity_token": token, "app": this.app}).then((response) => {
          if(response.body.saved){
            $(".ui.modal").modal("hide");
            this.$emit('saved', response.body.app);
          } else {
            this.error = "Failure saving";
          }
        }, (response) => {
          // FAILURE
          this.error = "Post fail";
        })
      },
      addUri: function() {
        this.app.uris.push("");
      },
      appReset: function() {
        this.app.name = null;
        this.app.uris = [""];
        this.app.expected_response_code = 200;
        this.app.expected_response_format = "json";
        this.app.expected_response_body = null;
      },
      cancelApp: function() {
        this.appReset();
        $(".ui.modal").modal("hide");
      }
    }
  }
</script>
