angular.module 'karmacrm.tasks.edit', [
  'karmacrm.tasks'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.tasks.form.edit',
    url: '/:taskId/edit'
    controller: 'TaskEditCtrl'
    templateUrl: 'tasks/taskForm/taskEdit/taskEdit.tpl.html'
    resolve:
      task: ($stateParams, Tasks) -> Tasks.get { id: $stateParams.taskId }

.controller 'TaskEditCtrl', ($scope, $state, task, TaskCompletion, $q, TaskContext, $ionicPopup) ->

  # make a copy of the task to be able to detect changes or cancel editing
  task.$promise.then (c) ->
    $scope.task = c
    $scope.editedTask = angular.copy c

  $scope.subentity =
    new_completion_note: ''

  $scope.hasChanges = () ->
    !angular.equals $scope.task, $scope.editedTask

  $scope.update = () ->
    promises = [] # all separate server calls to be waited for before leaving this view
    if $scope.editedTask.complete isnt $scope.task.complete
      promises.push(TaskCompletion.complete $scope.editedTask.id, $scope.editedTask.complete)
      if $scope.subentity.new_completion_note
        promises.push(TaskCompletion.note $scope.editedTask.id, $scope.subentity.new_completion_note)
    promises.push($scope.editedTask.$update())
    $q.all(promises).then () ->
      $state.go $scope.states.fromState.name, $scope.states.fromParams, {reload: yes} # If the save would return the new user ID, we could redirect to contact show

  $scope.delete = () ->
    $ionicPopup.confirm
      title: 'Delete a task'
      template: 'Are you sure you want to delete this task?'
    .then (res) ->
      task.$delete().then(() -> $state.go TaskContext.afterDeleteState.name, TaskContext.afterDeleteState.params, {reload: yes}) if res
