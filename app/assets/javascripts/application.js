//= require jquery
//= require jquery_ujs
//= require semantic_ui/semantic_ui
//= require chart_js/chart
//= require vue
//= require vue-router
//= require vue-resource
//= require vuex
//= require status_component
//= require_tree .

Vue.use(VueRouter);
Vue.use(VueResource);

var store = new Vuex.Store({
  state: {
    apps: {},
    environments: [],
    name: null,
    loading: true,
    statusMessage: null,
    modalApp: {},
    settings: null,
    formSettings: {}
  },
  mutations: {
    addApps: (state, payload) => {
      Vue.set(state.apps, payload.environment, payload.apps);
    },
    addApp: (state, payload) => {
      let index = state.apps[payload.environment].apps.findIndex(x => x._id.$oid == payload._id.$oid);
      if (index >= 0){
        state.apps[payload.environment].apps.splice(index, 1, payload);
      } else {
        state.apps[payload.environment].apps.push(payload)
      }
    },
    addSettings: (state, payload) => {
      state.settings = payload
      state.formSettings = payload
      state.environments = payload.environments;
      state.name = payload.name;
    },
    setLoading: (state, payload) => {
      state.loading = payload
    },
    setStatusMessage: (state, payload) => {
      state.statusMessage = payload
    },
    setModalApp: (state, payload) => {
      if (payload == null){
        state.modalApp = {}
        $("#appModal").modal("hide");
      } else {
        let app = Object.assign({}, payload)
        state.modalApp = app
        $("#appModal").modal("show");
      }
    },
    setModalAppField: (state, payload) => {
      Vue.set(state.modalApp, payload.field, payload.value)
    },
    setFormSettingsField: (state, payload) => {
      Vue.set(state.formSettings, payload.field, payload.value)
    },
    removeApp: (state, payload) => {
      let index = state.apps[payload.environment].apps.findIndex(x => x._id.$oid == payload._id.$oid);
      state.apps[payload.environment].apps.splice(index, 1);
    }
  },
  getters: {
    apps: state => {
      return state.apps;
    },
    appsList: state => {
      state.loading = true
      var list = []
      for (var environment in state.apps){
        list = list.concat(state.apps[environment].apps)
      }
      state.loading = false
      return list
    },
    loading: state => {
      return state.loading
    },
    name: state => {
      return state.name;
    },
    environments: state => {
      return state.environments
    },
    modalApp: state => {
      return state.modalApp
    },
    statusMessage: state => {
      return state.statusMessage
    },
    settings: state => {
      return state.settings
    },
    formSettings: state => {
      return state.formSettings
    }
  },
  actions: {
    fetchSettings: context => {
      context.commit('setLoading', true)
      Vue.http.get('/api/v1/settings')
                .then(response => response.json())
                .then(json => {
                  context.commit('addSettings', json.settings);
                  context.dispatch('fetchApps');
               })
    },
    // TODO: Combine fecthApps & UpdateApps
    fetchApps: context => {
      let environments = context.getters.environments;
      for (var index in environments) {
        let env = environments[index]
        Vue.http.get('/api/v1/statuses/' + env)
                .then(response => response.json())
                .then(json => {
                  context.commit('addApps', {
                    environment: env,
                    apps: json.statuses
                  })
                  context.dispatch('updateApps', env)
                });
      }
      context.commit('setLoading', false)
    },
    updateApps: (context, payload) => {
      setInterval(() => {
        let env = payload
        Vue.http.get('/api/v1/statuses/' + env)
                .then(response => response.json())
                .then(json => {
                  let apps = context.getters.apps
                  if (apps.hasOwnProperty(env)){
                    if (apps[env].down != json.statuses.down && apps[env].up != json.statuses.up) {
                      context.commit('addApps', {
                        environment: env,
                        apps: json.statuses
                      })
                    }
                  }
        })
      }, 15000);
    },
    deleteApp: (context, payload) => {
      let token = document.head.querySelector("[name=csrf-token]").content;
      Vue.http.headers.common["X-CSRF-Token"] = token;
      Vue.http.delete("/api/v1/apps", {"headers": {"X-APP-ID": payload._id.$oid}}).then((response) => {
        if(response.body.deleted){
          context.commit('removeApp', payload);
        }
      }, (response) => {
        this.status_message = 'Failed to delete app'
      })
    },
    editApp: (context, payload) => {
      context.commit('setModalApp', payload)
    },
    saveApp: context => {
      let token = document.head.querySelector("[name=csrf-token]").content;
      if (!$(".ui.form").form("is valid")){
        context.commit('setStatusMessage', "App is not valid, please check the URI and Response Code")
        return
      }
      Vue.http.post("api/v1/apps", {"authenticity_token": token, "app": context.getters.modalApp}).then((response) => {
        if(response.body.saved){
          context.commit('setModalApp', null);
          let app = JSON.parse(response.body.app)
          context.commit('addApp', app);
          context.commit('setStatusMessage', 'App Added')
        } else {
          context.commit('setStatusMessage', 'Failure saving')
        }
      }, (response) => {
        context.commit('setStatusMessage', 'Post fail')
      })
    },
    saveSettings: context => {
      context.commit('setLoading', true)
      let token = document.head.querySelector("[name=csrf-token]").content;
      Vue.http.post('/api/v1/settings', {'authenticity_token': token, 'settings': context.getters.formSettings}).then((response) => {
        context.commit('setStatusMessage', 'Settings Saved')
        let settings = JSON.parse(response.body.settings)
        context.commit('addSettings', settings)
        context.commit('setLoading', false)
      }, (response) => {
        context.commit('addSettings', 'Failed to save settings')
        context.commit('setLoading', false)
      })
    }
  }
})

// Populate the settings and apps on page load.
store.dispatch('fetchSettings');

const routes = [
  {
    path: "/",
    name: "status",
    component: VComponents["status_component"]
  },
  {
    path: "/settings",
    name: "settings",
    component: VComponents["settings_component"]
  },
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
  store
}).$mount("#app");

$(".ui.dropdown").dropdown();
$(".ui.checkbox").checkbox();
$(".ui.accordion").accordion();
$("#appModal").modal();
