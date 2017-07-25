<template>
  <div class="ui fluid card" v-bind:class="{ 'green': apps.down == 0, 'red': apps.down != 0 }">
    <div class="content">
      <div class="header">{{environment}}</div>
      <canvas v-bind:id="environment + 'Chart'" width="400" height="400"></canvas>
    </div>
  </div>
</template>

<script>
  module.exports = {
    name: 'status_pie_card',
    data: function(){
      return {
        rendered: false,
        chart: null
      }
    },
    mounted: function(){
      var ctx = document.getElementById(this.environment + "Chart").getContext('2d');
      if(this.rendered == false){
        this.chart = new Chart(ctx,{
            type: 'doughnut',
            data: this.createData(),
            options: {legend: {display: false}}
        });
        this.rendered = true;
      }
    },
    props: ['apps', 'environment'],
    methods: {
      createData: function(){
        var data = {
          datasets: [],
          labels: ['Up', 'Down'],
        }
        data.datasets.push({data: [this.apps.up, this.apps.down], backgroundColor: ["rgb(9, 182, 33)","rgb(230, 0, 19)"]})
        return data
      }
    }
  }
</script>
