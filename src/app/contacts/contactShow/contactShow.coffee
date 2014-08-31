angular.module 'karmacrm.contacts.show', [
  'karmacrm.contacts',
  'karmacrm.contacts.edit',
  'karmacrm.contacts.notes',
  'karmacrm.contacts.tasks'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.contacts.show',
    url: '/:contactId/show'
    controller: 'ContactShowCtrl'
    templateUrl: 'contacts/contactShow/contactShow.tpl.html'
    resolve:
      contact: ($stateParams, Contacts) -> Contacts.get { id: $stateParams.contactId }

.controller 'ContactShowCtrl', ($scope, contact, NoteContext, TaskContext, ContactNotes, ContactTasks) ->

  $scope.hasCustomValue = (customValue) -> customValue.fieldEntity.hasValue customValue

  contact.$promise.then (c) ->
    $scope.contact = c
    $scope.hasCustomValues = _.some(c.customValues, $scope.hasCustomValue)
    ContactNotes.get c.id
      .then (res) -> $scope.notes = res.data.results
    ContactTasks.get { contactId: c.id }
      .$promise.then (res) -> $scope.tasks = res.results
    TaskContext.setContext { participater_id: c.id, participater_type: 'Contact' }
    NoteContext.setContext { participater_id: c.id, participater_type: 'Contact' }
    TaskContext.afterDeleteState =
      name: 'app.contacts.tasklist'
      params: {contactId: c.id}
    NoteContext.afterDeleteState =
      name: 'app.contacts.notelist'
      params: {contactId: c.id}

  $scope.getCustomFieldDescriptors = () -> CustomFieldRepository.getCustomFieldDescriptors contact.field_values
  
  $scope.firstMobilePhone = () ->
    return null if !$scope.contact
    mobilePhones = _.where($scope.contact.phone_numbers, {phone_number_type_id: 2})
    _.first(mobilePhones)

  $scope.firstPhone = () ->
    return null if !$scope.contact
    $scope.firstMobilePhone() ? _.first($scope.contact.phone_numbers)
