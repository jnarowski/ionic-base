angular.module 'karmacrm.common.filter', []
.filter 'notDestroyed', () ->
  (list) ->
    _.reject list, (item) -> item._destroy