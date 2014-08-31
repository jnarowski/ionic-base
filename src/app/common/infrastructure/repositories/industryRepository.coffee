angular.module 'karmacrm.common.settings.industry', []
# Industry repository
.factory 'IndustryRepository', (SettingsRepository) ->
  industries =
    # cache the industries in memory
    _all: SettingsRepository.get('industries').results

    # returns all the industries as an array
    all: () -> industries._all
    
    getName: (id) ->
      _.find(industries._all, (industry) -> industry.id == id)?.name ? ''
