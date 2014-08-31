angular.module 'karmacrm.notes.form', [
  'karmacrm.notes'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.notes.form',
    abstract: yes
    url: ''
    controller: 'NoteFormCtrl'
    template: '<ion-nav-view/>'


.controller 'NoteFormCtrl', ($scope) ->
  $scope.isValid = (note) ->
    note?.body?.length > 0
