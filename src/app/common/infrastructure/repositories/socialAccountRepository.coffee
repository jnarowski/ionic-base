angular.module 'karmacrm.common.settings.social_account', []
# Social Account types repository
.factory 'SocialAccountTypesRepository', (SettingsRepository) ->
  socialAccountTypes =
    # cache the types in memory
    _all: SettingsRepository.get('social_account_types').results

    # returns all the social account types as an array
    all: () -> socialAccountTypes._all
    
    getName: (id) ->
      _.find(socialAccountTypes._all, (socialAccountType) -> socialAccountType.id == id)?.name ? ''
    
    # ID to use when a new social account is inserted
    defaultId: 1

.factory 'SocialAccountEntity', (SocialAccountTypesRepository) ->
  entity =
    name: 'SocialAccount'
    isEmpty: (account) -> account.name.length is 0
    createEmpty: ->
      social_account_type_id: SocialAccountTypesRepository.defaultId
      name: ''