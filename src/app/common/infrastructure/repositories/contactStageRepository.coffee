angular.module 'karmacrm.common.settings.contact_stage', []
# Contact Stage repository
.factory 'ContactStageRepository', (SettingsRepository) ->
  contactStages =
    # cache the contact stages in memory
    _all: SettingsRepository.get('contact_stages').results

    # returns all the contact stages as an array
    all: () -> contactStages._all
    
    getName: (id) ->
      _.find(contactStages._all, (source) -> source.id == id)?.name ? ''
