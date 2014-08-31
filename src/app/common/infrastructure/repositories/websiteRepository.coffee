angular.module 'karmacrm.common.settings.website', []
# Website types repository
.factory 'WebsiteTypesRepository', () ->
  websiteTypes =
    # cache the types in memory
    _all: [
      id: 1
      name: 'Work'
     ,
      id: 2
      name: 'Home'
     ,
      id: 3
      name: 'Other'
    ]

    # returns all the website types as an array
    all: () -> websiteTypes._all
    
    getName: (id) ->
      _.find(websiteTypes._all, (websiteType) -> websiteType.id == id)?.name ? ''
    
    # ID to use when a new website is inserted
    defaultId: 1

.factory 'WebsiteEntity', (WebsiteTypesRepository) ->
  entity =
    name: 'Website'
    isEmpty: (website) -> website.url.length is 0
    createEmpty: ->
      secondary_website_type_id: WebsiteTypesRepository.defaultId
      url: ''