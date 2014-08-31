angular.module 'karmacrm.contacts', [
  'ngResource',
  'karmacrm.common.server',
  'karmacrm.common.settings.custom_field',
  'karmacrm.common.selector',
  'karmacrm.common.filter',
  'karmacrm.common.filter.date',
  'karmacrm.common.settings.phone',
  'karmacrm.common.settings.email',
  'karmacrm.common.settings.social_account',
  'karmacrm.common.settings.website',
  'karmacrm.common.settings.address',
  'karmacrm.common.settings.country',
  'karmacrm.common.settings.industry',
  'karmacrm.common.settings.referral_source',
  'karmacrm.common.settings.tag',
  'karmacrm.common.settings.user',
  'karmacrm.common.settings.contact_status',
  'karmacrm.common.settings.contact_stage',
  'karmacrm.common.settings.company',
  'karmacrm.common.custom_field',
  'karmacrm.common.destroyable',
  'karmacrm.common.settings'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.contacts',
    abstract: true
    url: '/contacts'
    views:
      'menuContent':
        controller: 'ContactsCtrl'
        template: '<ion-nav-view/>'

.factory 'Contacts', ($resource, Server, CustomFieldTypesRepository, CustomFieldRepository) ->

  transformResponseCustomFieldValues = (contact) ->
    contact.customValues = []
    for customField in CustomFieldRepository.all()
      # create a new structure easy to UI
      customValue =
        customField: customField
        fieldEntity: CustomFieldTypesRepository.getEntity customField.field_type_id
        values: [] # for multiple valued fields like checkBoxes
        originalValues: [] # holds original field_value instances to be compared with when saving object
      customValue.value = customValue.fieldEntity.defaultValue # for single valued fields

      for contactValue in contact.field_values
        # literal values and options are recognized differently
        if contactValue.field_parent_id is customField.id or (contactValue.field_parent_id is null and contactValue.field_id is customField.id)
          customValue.value = customValue.fieldEntity.parseValue contactValue.value # parse from string to an appropriate type according to the field type
          customValue.values.push parseInt(contactValue.value) # Here cast is obvious as we have an option ID. If not, 'values' is not even used
          customValue.originalValues.push contactValue
      contact.customValues.push customValue

  transformRequestCustomFieldValues = (contact) ->
    return if !contact.customValues # new contacts have no custom values for the moment
    field_values = []
    for customValue in contact.customValues
      # each custom value is converted back into a single or multiple (for multi select fields) values
      if customValue.fieldEntity.hasOptions and customValue.fieldEntity.multiSelect
        # find removed options and mark them destroyed (original value options that are missing in the new values list)
        destroyed = _.filter(customValue.originalValues, (originalValue) -> _.every(customValue.values, (value) -> value isnt originalValue.field_id))
        for originalValue in destroyed
          originalValue._destroy = yes
          field_values.push originalValue

        # find newly selected options and create them
        added = _.filter(customValue.values, (value) -> _.every(customValue.originalValues, (originalValue) -> value isnt originalValue.field_id))
        for value in added
          fieldValue =
            value: String(value)
            field_type_id: customValue.customField.field_type_id
            field_parent_id: customValue.customField.id
            field_id: value
          field_values.push fieldValue

        # leave unchanged options that were selected and remained so
        unchanged = _.filter(customValue.originalValues, (originalValue) -> _.some(customValue.values, (value) -> value is originalValue.field_id))
        for originalValue in unchanged
          field_values.push originalValue

      else # zero or one former value is present in originalValues
        if !customValue.fieldEntity.hasValue customValue # former value has to be destroyed
          for originalValue in customValue.originalValues
            originalValue._destroy = yes
            field_values.push originalValue
        else # former value has to be updated if it exists, otherwise created
          if customValue.originalValues.length is 1 # length is 0 or 1
            customValue.originalValues[0].value = String(customValue.value) # the service always expects values as strings
            field_values.push customValue.originalValues[0]
          else # there is no former value, create one
            fieldValue =
              # we leave 'id' null as this is a new value
              value: String(customValue.value)
              field_type_id: customValue.customField.field_type_id
              # 'field_parent_id' is not null only for fields with options
              field_id: customValue.customField.id
            field_values.push fieldValue

    contact.field_values = field_values
    contact.customValues = undefined

  contacts =
    $resource Server.getApiUrl('contacts/:id.json'), {id: '@id'},
      get:
        method: 'GET'
        transformResponse: (contact) ->
          contact = angular.fromJson contact
          transformResponseCustomFieldValues contact
          contact
        
      # need to redefine 'query' as the default one expects an array
      query:
        method: 'GET'
        params: {}
      
      # redefining update to save existing contacts, and using PUT
      update:
        method: 'PUT'
        transformRequest: (data) ->
          transformRequestCustomFieldValues data
          angular.toJson
            contact: data

      save:
        method: 'POST'
        transformRequest: (data) ->
          transformRequestCustomFieldValues data
          angular.toJson
            contact: data

.factory 'ContactSearch', ($q, $http, Server) ->
  contactSearch =
    options:
      filter: ''
    search: (filter) ->
      q = $q.defer()
      if filter is ''
        q.resolve [] # we know an empty search doesn't return any results. Avoid a call to the server.
      else
        $http.get(Server.getApiUrl('search/sitewide.json') + '&result_type=backbone&search_indices=contacts&term=' + encodeURIComponent(filter))
          .then (res) ->
            q.resolve res.data.results
      q.promise

.controller 'ContactsCtrl', ($scope, Server,
  IndustryRepository, ReferralSourcesRepository, PhoneTypesRepository,
  EmailTypesRepository, SocialAccountTypesRepository, WebsiteTypesRepository, AddressTypesRepository, CountryRepository,
  UserRepository, ContactStatusRepository, ContactStageRepository) ->

  $scope.industries = IndustryRepository
  $scope.referralSources = ReferralSourcesRepository
  $scope.phoneTypes = PhoneTypesRepository
  $scope.emailTypes = EmailTypesRepository
  $scope.socialAccountTypes = SocialAccountTypesRepository
  $scope.websiteTypes = WebsiteTypesRepository
  $scope.addressTypes = AddressTypesRepository
  $scope.countries = CountryRepository
  $scope.users = UserRepository
  $scope.contactStatuses = ContactStatusRepository
  $scope.contactStages = ContactStageRepository

  $scope.avatarRoot = Server.domainRoot
