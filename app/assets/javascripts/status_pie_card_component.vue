<template>
  <div class="ui fluid card">
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
        chartData: {}
      }
    },
    mounted: function(){
      var ctx = document.getElementById(this.environment + "Chart").getContext('2d');
      var data = {
        datasets: [{
            data: [10, 20, 30]
        }],
        //v-bind:class="{ 'green': app.alive, 'red': !app.alive }"
        // These labels appear in the legend and in the tooltips when hovering different arcs
        labels: [
            'Red',
            'Yellow',
            'Blue'
        ]
      }
      if(this.rendered == false){
        var myPieChart = new Chart(ctx,{
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
        var up = 0
        var down = 0
        for(var app in this.apps){
          if (this.apps[app].alive){
            up += 1
          } else {
            down += 1
          }
        }
        data.datasets.push({data: [up, down], backgroundColor: ["rgb(9, 182, 33)","rgb(230, 0, 19)"]})
        return data
      }
    }
  }
</script>
