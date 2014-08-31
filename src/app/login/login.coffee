angular.module 'karmacrm.login', [
  'ui.router',
  'ionic',
  'karmacrm.common.user'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.login',
    url: '/login'
    views:
      'menuContent':
        controller: 'LoginCtrl'
        templateUrl: 'login/login.tpl.html'
    data:
      public: true # this state is marked public, making it aaccessible to anonymous users

.controller 'LoginCtrl', ($scope, $state, $ionicViewService, User) ->
  $scope.user = User.current()
  $scope.login = () ->
    User.login($scope.user).then (user) ->
      if user?
        #$ionicViewService.clearHistory()
        $state.go 'app.home'