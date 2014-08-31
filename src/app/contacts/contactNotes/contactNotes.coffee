angular.module 'karmacrm.contacts.notes', [
  'karmacrm.notes',
  'karmacrm.notes.show',
  'karmacrm.notes.new'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.contacts.notelist',
    url: '/:contactId/notes'
    controller: 'ContactNoteListCtrl'
    templateUrl: 'notes/noteList.tpl.html'
    resolve:
      notes: ($stateParams, ContactNotes) ->
        ContactNotes.get($stateParams.contactId).then (res) -> res.data.results

.controller 'ContactNoteListCtrl', ($scope, notes) ->
  $scope.notes = notes

.factory 'ContactNotes', ($http, Server) ->
  notes =
    get: (contactId) ->
      filter = {'filters[history_record_type]': 'Contact', 'filters[history_record_id]': contactId, per_page: 9999, page: 1, result_type: 'backbone'}
      $http.get Server.getApiUrl('histories.json'), {params: filter}