angular.module 'karmacrm', [
  'templates-app',
  'karmacrm.home',
  'karmacrm.about',
  'karmacrm.login',
  'karmacrm.account',
  'karmacrm.contacts',
  'karmacrm.contacts.list',
  'karmacrm.contacts.form',
  'karmacrm.tasks',
  'karmacrm.tasks.form',
  'karmacrm.notes',
  'karmacrm.notes.form',
  'karmacrm.common.user',
  'karmacrm.common.settings',
  'karmacrm.common.filter.date'
]
.config ($stateProvider, $urlRouterProvider) ->
  # When a bad URL is entered, redirect to home page
  $urlRouterProvider.otherwise '/home'

  $stateProvider.state 'app',
    # An abstract state cannot be activated by itself. A child state has to be activated and inherits properties of the parent.
    abstract: true,
    url: '',
    controller: 'AppCtrl',
    templateUrl: 'app.tpl.html',
    # Values of resolve have to be resolved before the state is activated.
    # It is used here to verify that the user is authenticated
    resolve:
      currentUser: ['Authorize', (Authorize) ->
        Authorize.authorize();
    ]

.run ($rootScope, $state, User, Authorize, Settings) ->
  $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
    #console.log '$stateChangeError', fromState.url, toState.url

  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    #console.log '$stateChangeStart', fromState.url, toState.url
    
    # to be used for back button (won't work when page is reloaded)
    $rootScope.states =
      fromState: fromState
      fromParams: fromParams
      toState: toState
      toParams: toParams
    
    # On each state change, we verify that the target state is granted to the current user
    Authorize.authorize()

  $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
    #console.log '$stateChangeSuccess', fromState.url, toState.url
    
  Settings.refresh()

.factory 'SitewideSearch', ($http, $window, Server) ->
  sitewide = 
    search: (filter) ->
      $http.get Server.getApiUrl('search/sitewide.json') + '&limit=9999&include_note_participants=true&full_note_body=true&result_type=backbone&search_indices=companies%2Ccontacts%2Cassets%2Ctodos%2Cdeals%2Ccases%2Cevents&term=' + $window.encodeURIComponent(filter)

.controller 'AppCtrl', ($scope, $state, $ionicModal, SitewideSearch, $ionicSideMenuDelegate) ->
  $scope.startSearch = () ->
    modalPromise = $ionicModal.fromTemplateUrl 'common/application/controls/sitewideSearch/sitewideSearch.tpl.html',
      scope: $scope
      animation: 'none'
      focusFirstInput: true
    modalPromise.then (modal) ->
      $scope.modal = modal
      $scope.options =
        search: ''
      $scope.search $scope.options.search
      $scope.cancel = () -> $scope.modal.hide()
      $scope.showItem = (item) ->
        modal.hide()
        $scope.options.search = ''
        $ionicSideMenuDelegate.toggleLeft false
        $state.go 'app.contacts.show', {contactId: item.id}, {location: 'replace'}
      modal.show()
  $scope.search = (filter) ->
    SitewideSearch.search filter
    .then (res) ->
      $scope.options.items = res.data.results