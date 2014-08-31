angular.module 'karmacrm.common.settings.address', []
# Address types repository
.factory 'AddressTypesRepository', (SettingsRepository) ->
  addressTypes =
    # cache the types in memory
    _all: SettingsRepository.get('address_types').results

    # returns all the address types as an array
    all: () -> addressTypes._all
    
    getName: (id) ->
      _.find(addressTypes._all, (addressType) -> addressType.id == id)?.name ? ''
    
    # ID to use when a new address is inserted
    defaultId: 1

.factory 'AddressEntity', (AddressTypesRepository) ->
  entity =
    name: 'Address'
    isEmpty: (address) ->
      address.street.length is 0 and
      address.city.length is 0 and
      address.state.length is 0 and
      address.country.length is 0 and
      address.postal_code.length is 0
    createEmpty: ->
      street: '',
      city: '',
      state: '',
      country: '',
      postal_code: '',
      address_type: AddressTypesRepository.defaultId