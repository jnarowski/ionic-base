angular.module 'karmacrm.contacts.new', [
  'karmacrm.contacts'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.contacts.form.new',
    url: '/new'
    controller: 'ContactNewCtrl'
    templateUrl: 'contacts/contactForm/contactEdit/contactEdit.tpl.html'

.controller 'ContactNewCtrl', ($scope, $state, Contacts, ContactFormMixin, ContactDestroyableLists) ->

  angular.extend $scope, ContactFormMixin

  $scope.editedContact = new Contacts()
  $scope.editedContact.phone_numbers = []
  $scope.editedContact.emails = []
  $scope.editedContact.social_accounts = []
  $scope.editedContact.websites = []
  $scope.editedContact.addresses = []
  $scope.editedContact.customValues = []
  $scope.editedContact.field_values = []
  $scope.editedContact.tag_list = []

  ContactDestroyableLists.create $scope

  $scope.hasChanges = () -> true

  $scope.update = () ->
    # remove empty phones added for UI
    ContactDestroyableLists.destroy()

    # if a former field has been cleared, mark it as _destroy    
    for fieldDesc in $scope.editedContact.field_values
      if fieldDesc.id and fieldDesc.value is ''
        fieldDesc._destroy = yes
    # cleanup custom field descriptors without a value nor an ID
    $scope.editedContact.field_values = _.filter $scope.editedContact.field_values, (fieldDesc) -> fieldDesc._destroy or fieldDesc.id

    $scope.editedContact.$save().then () ->
      $state.go 'app.contacts.list', {}, {reload: yes} # If the save would return the new user ID, we could redirect to contact show
