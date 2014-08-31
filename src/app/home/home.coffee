angular.module 'karmacrm.home', [
  'ionic',
  'karmacrm.about'
]

.config ($stateProvider) ->
  $stateProvider.state 'app.home',
    abstract: false
    url: '/home'
    views:
      menuContent:
        templateUrl: 'home/home.tpl.html'
        controller: 'HomeCtrl'

.controller 'HomeCtrl', ($scope, $state) ->
  #alert('home ctrl');
