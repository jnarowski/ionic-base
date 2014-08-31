angular.module 'karmacrm.common.settings.tag', [
  'karmacrm.common.storage'
]

# Settings repository
.factory 'TagRepository', (KeyValueRepository) ->
  prefix = 'settings'
  listName = 'tags'
  repository =
    store: (tagList) ->
      KeyValueRepository.set prefix, listName, tagList

    get: () ->
      KeyValueRepository.get prefix, listName

    add: (tag) ->
      tagList = repository.get()
      tagList.push tag
      tagList = _.uniq tagList
      repository.store tagList

.factory 'TagEntity', () ->
  entity =
    name: 'Tag'
    isEmpty: (tag) -> tag.length is 0
    createEmpty: -> ''

    canDelete: (list, testedItem, isEmpty) ->
      if !isEmpty(testedItem)
        return yes
      lastEmpty = null
      for item in list
        do (item) ->
          if isEmpty(item)
            lastEmpty = item
      return testedItem isnt lastEmpty

    deleteItem: (list, item) ->
      list.splice _.indexOf(list, item), 1
    
    hasEmpty: (list, isEmpty) ->
      _.some list, (item) -> isEmpty(item)
    
    findRemovable: (list, isEmpty) ->
      _.find list, ((item) -> isEmpty(item))