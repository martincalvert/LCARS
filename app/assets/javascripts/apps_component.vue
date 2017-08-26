<template>
  <div class="ui grid">
    <div class="ui divider horizontal"></div>
    <div class="row">
      <div class="twelve wide column centered">
        <div class="row single line">
          <h1>
            Apps
            <div class="ui right floated small primary labeled icon button" v-on:click="setModalApp({})">
              <i class="add circle icon"></i> Add App
            </div>
          </h1>
        </div>
        <table class="ui padded table">
          <thead class="full-width">
            <tr>
              <th>Name</th>
              <th>URI</th>
              <th>Response Code</th>
              <th>Environment</th>
              <th>Enabled</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <appRow v-for="app in appsList" :app="app" :key="app._id"></appRow>
          </tbody>
        </table>
      </div>
    </div>
    <appModal></appModal>
  </div>
</template>

<script>
  var appRow = VComponents["app_component"];
  var appModal = VComponents["app_modal_component"];
  module.exports = {
    name: "apps",
    data: function(){
      return {}
    }, created: function() {

    }, computed: Vuex.mapGetters([
        'apps',
        'appsList',
        'modalApp'
    ]),
    methods: Vuex.mapMutations([
      'setModalApp'
    ]),
    components: {
      "appRow": appRow,
      "appModal": appModal
    }
  }
</script>
