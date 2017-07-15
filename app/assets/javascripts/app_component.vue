<template>
  <tr>
    <td>
      <h2 class="ui center aligned header">
        {{app.name}}
      </h2>
    </td>
    <td>
      <span v-for="uri in app.uris">
        {{uri}} <br>
      </span>
    </td>
    <td>
      {{app.expected_response_code}}
    </td>
    <td>
      {{app.expected_response_format}}
    </td>
    <td>
      {{app.environment}}
    </td>
    <td>
      {{app.enabled}}
    </td>
    <td>
      <div class="actions">
        <div class="ui orange icon button" v-on:click="emit('delete')">
          <i class="trash icon"></i>
        </div>
        <div class="ui teal icon button" v-on:click="emit('edit')">
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
      emit: function(action) {
        this.$emit(action, this.app);
      }
    }
  }
</script>
