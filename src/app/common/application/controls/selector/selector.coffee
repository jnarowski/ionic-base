angular.module 'karmacrm.common.selector', []

.factory 'Selector', ($rootScope, $state, $q, $ionicModal) ->
  selector =
    show: (options) ->
      q = $q.defer()
      scope = $rootScope.$new()
      
      defaultOptions =
        items: null # expects an array of objects having 'id' and 'name' fields
        filterFn: null # function taking a string and returning a promise
        search: ''
        selected: null # value of the currently selected item matching an 'id' value from the 'items' array, or array of values in case of a multiselect
        multiSelect: no
        title: 'Selector'

      scope.options = angular.extend defaultOptions, options
      
      # set '_selector_item_selected' property for multiselect checkbox data binding
      # should only be called for multiselect
      initItemSelectedState = (items) ->
        _.each(items, (item) -> item._selector_item_selected = item.id in scope.options.selected)
      clearItemSelectedState = (items) ->
        _.each(items, (item) -> item._selector_item_selected = undefined)
      initItemSelectedState scope.options.items if scope.options.multiSelect
      
      scope.cancel = ->
        scope.modal.hide().then (modal) ->
          # cleanup to avoid memory leaks
          scope.modal.remove() # cleanup modal and DOM
          scope.$destroy() # remove unused scope

      scope.clearFilter = ->
        scope.options.search = ''
        scope.onFilterChange ''

      exec = (search) ->
        scope.options.filterFn search
        .then (items) ->
          initItemSelectedState items if scope.options.multiSelect
          scope.options.items = items
      throttledFilter =
        _.throttle((search) ->
          if !scope.$$phase then scope.$apply(()->exec(search)) else exec(search)
        , 500)

      scope.onFilterChange = (search) ->
        throttledFilter search

      # an item has been checked in a mono select list
      scope.onCheck = (item) ->
        q.resolve item
        scope.cancel()
      
      scope.apply = () ->
        q.resolve _.where(scope.options.items, { _selector_item_selected: yes } )
        clearItemSelectedState scope.options.items
        scope.cancel()
      
      template = 'common/application/controls/selector/selector' + (if scope.options.multiSelect then 'Multi.tpl.html' else '.tpl.html')

      modalPromise = $ionicModal.fromTemplateUrl template,
        scope: scope
        animation: 'slide-in-right'
      modalPromise.then (modal) ->
        scope.modal = modal
        scope.onFilterChange(scope.options.search) if scope.options.filterFn?
        modal.show()

      q.promise