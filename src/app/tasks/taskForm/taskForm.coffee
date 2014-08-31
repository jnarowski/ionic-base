angular.module 'karmacrm.tasks.form', [
  'karmacrm.tasks'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.tasks.form',
    abstract: yes
    url: ''
    controller: 'TaskFormCtrl'
    template: '<ion-nav-view/>'


.controller 'TaskFormCtrl', ($scope) ->
  $scope.isValid = (task) ->
    task?.body?.length > 0
