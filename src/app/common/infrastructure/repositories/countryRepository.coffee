angular.module 'karmacrm.common.settings.country', []
# Country repository
.factory 'CountryRepository', (SettingsRepository) ->
  countries =
    # cache the countries in memory
    _all: SettingsRepository.get('countries').results

    # returns all the countries as an array
    all: () -> countries._all
    
    getName: (id) ->
      _.find(countries._all, (country) -> country.id == id)?.name ? ''
