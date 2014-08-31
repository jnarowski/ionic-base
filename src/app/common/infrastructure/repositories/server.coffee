angular.module 'karmacrm.common.server', [
  'karmacrm.common.user'
]

.factory 'Server', (User) ->
  server =
    domainRoot: 'https://app.karmacrm.com'
    apiRoot: 'https://app.karmacrm.com/api/v2/'
    getApiUrl: (apiPath) ->
      path = server.apiRoot + apiPath
      token = User.getToken()
      path = path + '?api_token=' + token if token
      return path