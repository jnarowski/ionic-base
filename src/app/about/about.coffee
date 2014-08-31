angular.module 'karmacrm.about', [
  'ui.router'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.about',
    url: '/about'
    views:
      'menuContent':
        controller: 'AboutCtrl'
        templateUrl: 'about/about.tpl.html'

.controller 'AboutCtrl', ($scope, $state) ->