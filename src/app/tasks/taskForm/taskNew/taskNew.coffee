angular.module 'karmacrm.tasks.new', [
  'karmacrm.tasks'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.tasks.form.new',
    url: '/new'
    controller: 'TaskNewCtrl'
    templateUrl: 'tasks/taskForm/taskEdit/taskEdit.tpl.html'

.controller 'TaskNewCtrl', ($scope, $state, Tasks, TaskContext) ->

  $scope.editedTask = new Tasks()
  $scope.editedTask.comments = []
  $scope.editedTask.participants = []

  $scope.hasChanges = () -> true

  $scope.update = () ->
    $scope.editedTask.participants.push TaskContext.getContext()
    $scope.editedTask.$save().then () ->
      $state.go $scope.states.fromState.name, $scope.states.fromParams, {reload: yes} # If the save would return the new user ID, we could redirect to contact show
