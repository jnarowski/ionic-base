angular.module 'karmacrm.tasks.show', [
  'karmacrm.tasks',
  'karmacrm.tasks.edit'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.tasks.show',
    url: '/:taskId/show'
    controller: 'TaskShowCtrl'
    templateUrl: 'tasks/taskShow/taskShow.tpl.html'
    resolve:
      task: ($stateParams, Tasks) -> Tasks.get { id: $stateParams.taskId }

.controller 'TaskShowCtrl', ($scope, task) ->
  task.$promise.then (t) ->
    $scope.task = t
