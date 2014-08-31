angular.module 'karmacrm.account', [
  'ui.router',
  'ionic',
  'karmacrm.common.user'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.account',
    url: '/account'
    views:
      'menuContent':
        controller: 'AccountCtrl'
        templateUrl: 'account/account.tpl.html'

.controller 'AccountCtrl', ($scope, $state, $ionicViewService, User) ->
  $scope.user = User.current()
  $scope.logout = () ->
    User.logout()
    #$ionicViewService.clearHistory()
    $state.go 'app.login'