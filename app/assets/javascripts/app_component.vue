<template>
  <tr>
    <td>
      <h3 class="ui center aligned header">
        {{app.name}}
      </h3>
    </td>
    <td>
        {{app.uri}}
    </td>
    <td>
      {{app.expected_response_code}}
    </td>
    <td>
      {{app.environment}}
    </td>
    <td>
      {{app.enabled}}
    </td>
    <td>
      <div class="actions">
        <div class="ui orange icon button" v-on:click="deleteApp(app)">
          <i class="trash icon"></i>
        </div>
        <div class="ui teal icon button" v-on:click="setModalApp(app)">
          <i class="edit icon"></i>
        </div>
      </div>
    </td>
  </tr>
</template>

<script>
  module.exports = {
    name: "app",
    data: function(){
      return {}
    },
    props: ["app"],
    methods: {
      ...Vuex.mapActions([
        'deleteApp'
      ]),
      ...Vuex.mapMutations([
        'setModalApp'
      ])
    }
  }
</script>
