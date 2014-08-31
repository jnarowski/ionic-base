angular.module 'karmacrm.common.destroyable', []

# A DestroyableList is a list of items like phone numbers that the user can insert or delete.
# An empty row is always present during editing, and has to be removed before updating to the server.
.factory 'DestroyableList', () ->
  _canDelete = (list, testedItem, isEmpty) ->
    if !isEmpty(testedItem)
      return yes
    lastEmpty = null
    for item in list
      do (item) ->
        if !item._destroy and isEmpty(item)
          lastEmpty = item
    return testedItem isnt lastEmpty

  _deleteItem = (list, item) ->
    if !item.id
      list.splice _.indexOf(list, item), 1
    else
      item._destroy = yes

  _hasEmpty = (list, isEmpty) ->
    _.some list, (item) -> !item._destroy and isEmpty(item)


  class DestroyableList
    constructor: (@scope, @list, @entity) ->
      canDelete = @entity.canDelete ? _canDelete
      deleteItem = @entity.deleteItem ? _deleteItem
      hasEmpty = @entity.hasEmpty ? _hasEmpty

      # checks whether this item can be deleted, in order to keep a last empty item ready to be filled
      @scope['canDelete' + @entity.name] =
        (item) -> canDelete list, item, entity.isEmpty

      @scope['delete' + @entity.name] =
        (item) -> deleteItem list, item

      # finds whether there is an empty item that has not been destroyed
      @scope['hasEmpty' + @entity.name] = () -> hasEmpty list, entity.isEmpty

      # watching the fact that the last empty row has been filled, triggering insertion of a new one
      this.itemUnwatch = @scope.$watch 'hasEmpty' + @entity.name + '()', (newValue) ->
        list.push entity.createEmpty() if !newValue

    destroy: ->
      @itemUnwatch() # prevent the watcher from adding empty rows again

      # remove empty items except those flagged _destroy
      isEmpty = @entity.isEmpty
      findRemovable = @entity.findRemovable ? (list, isEmpty) -> _.find list, ((item) -> !item._destroy and isEmpty(item))
      itemToRemove = null
      while itemToRemove = findRemovable @list, isEmpty
        @list.splice _.indexOf(@list, itemToRemove), 1
