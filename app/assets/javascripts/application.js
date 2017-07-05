// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require semantic_ui/semantic_ui
//= require vue
//= require vue-router
//= require vue-resource
//= require vuex
//= require status_component
//= require_tree .

Vue.use(VueRouter);
Vue.use(VueResource);

const routes = [
  {
    path: "/",
    name: "status",
    component: VComponents["status_component"]
  },
  // {
  //   path: '/',
  //   name: 'errors',
  //   component: VComponents['status_component']
  // },
  {
    path: "/apps",
    name: "apps",
    component: VComponents["apps_component"]
  }
];

const router = new VueRouter({
  routes
});

var app = new Vue({
  data: { user: {} },
  router,
}).$mount("#app");

$(".ui.dropdown").dropdown();
$(".ui.checkbox").checkbox();
