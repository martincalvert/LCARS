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
      {{app.expected_response_body}}
    </td>
  </tr>
</template>

<script>
  module.exports = {
    name: 'app',
    data: function(){
      return {}
    },
    props: ['app'],
  }
</script>
