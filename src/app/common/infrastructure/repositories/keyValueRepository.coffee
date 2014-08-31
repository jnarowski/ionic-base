angular.module 'karmacrm.common.storage', []

# Generic Key/Value repository. Stores objects using JSON serialization into localStorage
.factory 'KeyValueRepository', () ->
  keyValueRepository =
    get: (prefix, key) ->
      angular.fromJson window.localStorage.getItem prefix + '-' + key
    set: (prefix, key, value) ->
      window.localStorage.setItem prefix + '-' + key, angular.toJson value
    remove: (prefix, key) ->
      window.localStorage.removeItem prefix + '-' + key
