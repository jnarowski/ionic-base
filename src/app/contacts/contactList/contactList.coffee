angular.module 'karmacrm.contacts.list', [
  'karmacrm.contacts',
  'karmacrm.contacts.show',
  'karmacrm.contacts.new'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.contacts.list',
    url: '/list'
    controller: 'ContactListCtrl'
    templateUrl: 'contacts/contactList/contactList.tpl.html'

.controller 'ContactListCtrl', ($scope, ContactSearch) ->
  $scope.options = ContactSearch.options
  
  $scope.onFilterChange = (filter) ->
    ContactSearch.search filter
      .then (res) ->
        $scope.contacts = res

  # call the last search to have a consistent experience when hitting 'back'
  $scope.onFilterChange $scope.options.search