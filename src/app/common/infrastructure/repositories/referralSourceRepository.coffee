angular.module 'karmacrm.common.settings.referral_source', []
# Referral Sources repository
.factory 'ReferralSourcesRepository', (SettingsRepository) ->
  referralSources =
    # cache the referral sources in memory
    _all: SettingsRepository.get('referral_sources').results

    # returns all the referral sources as an array
    all: () -> referralSources._all
    
    getName: (id) ->
      _.find(referralSources._all, (source) -> source.id == id)?.name ? ''
