angular.module 'karmacrm.common.settings.contact_status', []
# Contact Status repository
.factory 'ContactStatusRepository', (SettingsRepository) ->
  contactStatuses =
    # cache the contact statuses in memory
    _all: SettingsRepository.get('contact_statuses').results

    # returns all the contact statuses as an array
    all: () -> contactStatuses._all
    
    getName: (id) ->
      _.find(contactStatuses._all, (source) -> source.id == id)?.name ? ''
