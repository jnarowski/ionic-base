angular.module 'karmacrm.common.settings', [
  'karmacrm.common.server',
  'karmacrm.common.storage'
]

# Settings repository
.factory 'SettingsRepository', (KeyValueRepository) ->
  prefix = 'settings'
  repository =
    # checks whether any settings loading from the server has been done, to either trigger a full or individual load
    isEmpty: () -> (KeyValueRepository.get prefix, 'EmptyRepository') is null

    # reads the timestamp from the stored list setting, otherwise 0
    getTimestamp: (listName) ->
      setting = KeyValueRepository.get prefix, listName
      setting?.timestamp ? 0 # either a timestamp is defined or we consider too old (most ancient date is 0)

    store: (listName, setting) ->
      KeyValueRepository.set prefix, 'EmptyRepository', false
      KeyValueRepository.set prefix, listName, setting

    get: (listName) ->
      KeyValueRepository.get prefix, listName

# Settings service
.factory 'Settings', ($resource, SettingsRepository, Server) ->
  settings =
    # loads the list setting from the server and stores the result
    reload: (listName) ->
      setting = $resource(Server.getApiUrl 'settings/:listName.json').get({listName: listName}, () ->
        SettingsRepository.store listName, setting
      )

    refresh: () ->
      if SettingsRepository.isEmpty() then settings.refreshFull() else settings.refreshIndividually()
      
    refreshFull: () ->
      fullSettings = $resource(Server.getApiUrl 'settings/settings/full.json').get({}, () ->
        angular.forEach fullSettings.settings, (setting, listName) ->
          SettingsRepository.store listName, setting
      )

    refreshIndividually: () ->
      currentTimestamps = $resource(Server.getApiUrl 'settings_timestamps.json').get({}, () ->
        angular.forEach currentTimestamps, (timestamp, listName) ->
          # skip settings that are known to be missing or failing
          return if listName in ['location_types', 'form', 'section', 'integrations']
          if angular.isNumber timestamp # filter out internal Angular object properties, TODO: handle it with native Angular methods
            storedTs = SettingsRepository.getTimestamp listName
            currentTs = currentTimestamps?[listName]
            settings.reload listName if storedTs < currentTs
      )

