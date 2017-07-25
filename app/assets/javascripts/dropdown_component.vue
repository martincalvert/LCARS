<template>
  <div class="ui selection dropdown">
    <i class="dropdown icon"></i>
    <div class="default text">{{defaultText}}</div>
    <div class="menu">
      <div v-for="item in items" class="item" :data-value="item">{{ item }}</div>
    </div>
    <input type="hidden" :value="value">
  </div>
</template>

<script>
  module.exports = {
    name: 'dropdown',
    data: function(){
      return {}
    },
  	props: ['items', 'value', 'defaultText'],
  	watch: {
  		value: function (val, oldVal) {
  			if(val == null) {
  				$(this.$el).dropdown('clear');
  			}
  		}
  	},
  	mounted() {
  		var t = this;
  		$(t.$el).dropdown('refresh').dropdown({onChange: function (value, text, $choice) {
  			t.$emit('input', value);
  		}});
  	},
    updated() {
      $(this.$el).dropdown()
    }
  }
</script>
