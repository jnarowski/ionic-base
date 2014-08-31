angular.module 'karmacrm.common.settings.phone', []
# Phone types repository
.factory 'PhoneTypesRepository', (SettingsRepository) ->
  phoneTypes =
    # cache the types in memory
    _all: SettingsRepository.get('phone_number_types').results

    # returns all the phone types as an array
    all: () -> phoneTypes._all
    
    getName: (id) ->
      _.find(phoneTypes._all, (phoneType) -> phoneType.id == id)?.name ? ''
    
    # ID to use when a new phone is inserted
    defaultId: 1

.factory 'PhoneEntity', (PhoneTypesRepository) ->
  entity =
    name: 'Phone'
    isEmpty: (phone) -> phone.number.length is 0
    createEmpty: ->
      phone_number_type_id: PhoneTypesRepository.defaultId
      number: ''