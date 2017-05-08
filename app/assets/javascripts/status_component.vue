//= require status_card_component
<template>
  <div>
    <div class="ui divider"></div>
    <div class="ui container column grid">
      <h1>Current Statuses</h1>
    </div>
    <div class="ui container grid">
      <div class="four wide column" v-for="card in cards">
        <card></card>
      </div>
    </div>
  </div>
</template>

<script>
  var card = VComponents['status_card_component']
  module.exports = {
    name: 'status',
    data: function(){
      return {
        cards: [1,2,3,4]
      }
    },
    components: {
      'card': card
    }
  }
</script>
