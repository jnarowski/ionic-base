angular.module 'karmacrm.common.settings.user', []
# Users  repository
.factory 'UserRepository', (SettingsRepository) ->
  users =
    # cache the users in memory
    _all: SettingsRepository.get('users').results

    # returns all the users as an array
    all: () -> users._all
    
    getName: (id) ->
      u = _.find(users._all, (user) -> user.id == id)
      if u? then u.first_name + ' ' + u.last_name else ''
