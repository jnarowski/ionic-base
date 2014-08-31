angular.module 'karmacrm.notes.edit', [
  'karmacrm.notes'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.notes.form.edit',
    url: '/:noteId/edit'
    controller: 'NoteEditCtrl'
    templateUrl: 'notes/noteForm/noteEdit/noteEdit.tpl.html'
    resolve:
      note: ($stateParams, Notes) -> Notes.get { id: $stateParams.noteId }

.controller 'NoteEditCtrl', ($scope, $state, note, $q, $ionicPopup, NoteContext) ->

  # make a copy of the note to be able to detect changes or cancel editing
  note.$promise.then (c) ->
    $scope.note = c
    $scope.editedNote = angular.copy c

  $scope.subentity =
    new_completion_note: ''

  $scope.hasChanges = () ->
    !angular.equals $scope.note, $scope.editedNote

  $scope.update = () ->
    $scope.editedNote.$update().then () ->
      $state.go $scope.states.fromState.name, $scope.states.fromParams, {reload: yes} # If the save would return the new user ID, we could redirect to contact show

  $scope.delete = () ->
    $ionicPopup.confirm
      title: 'Delete a note'
      template: 'Are you sure you want to delete this note?'
    .then (res) ->
      note.$delete().then(() -> $state.go NoteContext.afterDeleteState.name, NoteContext.afterDeleteState.params, {reload: yes}) if res
