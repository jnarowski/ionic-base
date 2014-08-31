angular.module 'karmacrm.contacts.edit', [
  'karmacrm.contacts',
  'karmacrm.tasks'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.contacts.form.edit',
    url: '/:contactId/edit'
    controller: 'ContactEditCtrl'
    templateUrl: 'contacts/contactForm/contactEdit/contactEdit.tpl.html'
    resolve:
      contact: ($stateParams, Contacts, $q) ->
        q = $q.defer()
        Contacts.get { id: $stateParams.contactId }
        .$promise.then (c) ->
          c.tag_list = c.tag_list || [] # Normalize the tag list that must at least be an empty list
          q.resolve c
        q.promise

.controller 'ContactEditCtrl', ($scope, $state, contact, ContactFormMixin, ContactDestroyableLists) ->

  angular.extend $scope, ContactFormMixin

  ContactDestroyableLists.clear()

  # make a copy of the contact to be able to detect changes or cancel editing
  contact.$promise.then (c) ->
    $scope.contact = c
    $scope.editedContact = angular.copy c
    ContactDestroyableLists.create $scope

  $scope.hasChanges = () ->
    !angular.equals $scope.contact, $scope.editedContact
  
  $scope.update = () ->
    # remove empty phones added for UI
    ContactDestroyableLists.destroy()

    # if a former field has been cleared, mark it as _destroy    
    for fieldDesc in $scope.editedContact.field_values
      if fieldDesc.id and fieldDesc.value is ''
        fieldDesc._destroy = yes
    # cleanup custom field descriptors without a value nor an ID
    $scope.editedContact.field_values = _.filter $scope.editedContact.field_values, (fieldDesc) -> fieldDesc._destroy or fieldDesc.id

    $scope.editedContact.$update().then () ->
      $state.go 'app.contacts.show',
        contactId: $scope.contact.id
       ,
        reload: yes

  $scope.delete = () ->
    $ionicPopup.confirm
      title: 'Delete a contact'
      template: 'Are you sure you want to delete this contact?'
    .then (res) ->
      contact.$delete().then(() -> $state.go 'app.contacts.list', {}, {reload: yes}) if res
