angular.module 'karmacrm.notes.new', [
  'karmacrm.notes',
  'karmacrm.common.note_type'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.notes.form.new',
    url: '/new'
    controller: 'NoteNewCtrl'
    templateUrl: 'notes/noteForm/noteEdit/noteEdit.tpl.html'

.controller 'NoteNewCtrl', ($scope, $state, Notes, NoteContext, NoteTypeRepository) ->

  $scope.editedNote = new Notes()
  $scope.editedNote.contact_type_id = NoteTypeRepository.Note
  $scope.editedNote.participants = []

  $scope.hasChanges = () -> true

  $scope.update = () ->
    $scope.editedNote.date = moment().format('MM/DD/YYYY')
    $scope.editedNote.time = moment().format('h:mma')
    noteContext = NoteContext.getContext()
    $scope.editedNote.parent_id = noteContext.participater_id
    $scope.editedNote.parent_type = noteContext.participater_type
    $scope.editedNote.$save().then () ->
      $state.go $scope.states.fromState.name, $scope.states.fromParams, {reload: yes} # If the save would return the new user ID, we could redirect to contact show
