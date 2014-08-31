angular.module 'karmacrm.notes.show', [
  'karmacrm.notes',
  'karmacrm.notes.edit'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.notes.show',
    url: '/:noteId/show'
    controller: 'NoteShowCtrl'
    templateUrl: 'notes/noteShow/noteShow.tpl.html'
    resolve:
      note: ($stateParams, Notes) -> Notes.get { id: $stateParams.noteId }

.controller 'NoteShowCtrl', ($scope, note) ->
  note.$promise.then (t) ->
    $scope.note = t
