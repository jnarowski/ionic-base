angular.module 'karmacrm.contacts.tasks', [
  'karmacrm.tasks',
  'karmacrm.tasks.show',
  'karmacrm.tasks.new'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.contacts.tasklist',
    url: '/:contactId/tasks'
    controller: 'ContactTaskListCtrl'
    templateUrl: 'tasks/taskList.tpl.html'
    resolve:
      tasks: ($stateParams, ContactTasks) -> ContactTasks.get { contactId: $stateParams.contactId }

.controller 'ContactTaskListCtrl', ($scope, tasks) ->
  tasks.$promise.then (res) -> $scope.tasks = res.results

.factory 'ContactTasks', ($resource, Server) ->
  tasks =
    $resource Server.getApiUrl('contacts/:contactId/todos.json'), {contactId: '@contactId'}, {}