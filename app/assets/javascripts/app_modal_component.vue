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
        </form>
      </div>
    </div>
    <div class="actions">
      <div class="ui red right labeled icon button">
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
    name: 'appModal',
    data: function(){
      return {
        app: {
          name: null,
          uris: [''],
          expected_response_code: 200,
          expected_response_format: 'json',
          expected_response_body: null
         }
      }
    },
    methods: {
      saveApp: function() {
        let token = document.head.querySelector("[name=csrf-token]").content;
        this.$http.post('api/v1/apps', {'authenticity_token': token, 'app': this.app}).then((response) => {
          if(response.body.saved){
            this.appReset()
            this.$emit('saved', response.body.app)
            $('.ui.modal').modal('hide')
          } else {
            this.error = 'Failure saving'
          }
        }, (response) => {
          // FAILURE
          this.error = 'Post fail'
        })
      },
      addUri: function() {
        this.app.uris.push('')
      },
      appReset: function() {
        this.app.name = null
        this.app.uris = ['']
        this.app.expected_response_code = 200
        this.app.expected_response_format = 'json'
        this.app.expected_response_body = null
      }
    }
  }
</script>
