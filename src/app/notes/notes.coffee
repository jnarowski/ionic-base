angular.module 'karmacrm.notes', [
  'ngResource',
  'karmacrm.common.server'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.notes',
    abstract: true
    url: '/notes'
    views:
      'menuContent':
        controller: 'NotesCtrl'
        template: '<ion-nav-view/>'

.factory 'Notes', ($resource, Server) ->
  notes =
    $resource Server.getApiUrl('notes/:id.json'), {id: '@id'},
      update:
        method: 'PUT'
        transformRequest: (data) ->
          angular.toJson
            note: data

      save:
        method: 'POST'
        transformRequest: (data) ->
          angular.toJson
            note: data

      get:
        method: 'GET'
        url: Server.getApiUrl('histories/:id.json')
        params: {id: '@id'}

      update:
        method: 'PUT'
        url: Server.getApiUrl('histories/:id.json')
        params: {id: '@id'}
        transformRequest: (data) ->
          angular.toJson
            history:
              external:
                body: data.body
                contact_type_id: data.history_type_id

      delete:
        method: 'DELETE'
        url: Server.getApiUrl('histories/:id.json')
        params: {id: '@id'}
        

.factory 'NoteContext', () ->
  noteContext =
    context: null
    setContext: (context) -> noteContext.context = context
    getContext:() -> noteContext.context
    afterDeleteState: null

.controller 'NotesCtrl', ($scope, Server) ->
  