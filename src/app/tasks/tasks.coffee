angular.module 'karmacrm.tasks', [
  'ngResource',
  'karmacrm.common.server'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.tasks',
    abstract: true
    url: '/tasks'
    views:
      'menuContent':
        controller: 'TasksCtrl'
        template: '<ion-nav-view/>'

.factory 'Tasks', ($resource, Server) ->
  tasks =
    $resource Server.getApiUrl('todos/:id.json'), {id: '@id'},
      update:
        method: 'PUT'
        transformRequest: (data) ->
          angular.toJson
            todo: data

      save:
        method: 'POST'
        transformRequest: (data) ->
          angular.toJson
            todo: data

.factory 'TaskCompletion', ($http, Server) ->
  completion =
    complete: (taskId, isComplete) ->
      action = if isComplete then 'complete' else 'uncomplete'
      $http.put Server.getApiUrl('todos/' + taskId + '/' + action + '.json'), {}
    note: (taskId, note) ->
      $http.put Server.getApiUrl('todos/' + taskId + '.json'), {todo: {completion_notes: note}}

.factory 'TaskContext', () ->
  taskContext =
    context: null
    setContext: (context) -> taskContext.context = context
    getContext:() -> taskContext.context
    afterDeleteState: null

.controller 'TasksCtrl', ($scope, Server) ->
  