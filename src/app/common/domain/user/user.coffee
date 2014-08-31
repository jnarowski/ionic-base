angular.module 'karmacrm.common.user', [
  'karmacrm.common.storage'
]

.factory 'User', ($q, $http, $resource, KeyValueRepository) ->
  localStoragePrefix = 'Authentication'
  localStorageUserKey = 'User'
  currentUser = undefined
  authenticated = false
  u =
    login: (user) ->
      q = $q.defer()

      $http.post('https://app.karmacrm.com/accounts/sign_in',
        account:
          email: user.login
          password: user.password
       ,
        headers:
          'Content-Type': 'application/json'
          'Accept': 'application/json'
      )
      .then((res) ->
        if res.data.id
          currentUser = {
            login: res.data.email,
            password: user.password,
            id: res.data.id,
            token: res.data.api_token
          }
          KeyValueRepository.set localStoragePrefix, localStorageUserKey, currentUser
          q.resolve currentUser
        else
          q.reject()
      )

      q.promise

    hasCredentials: () ->
      currentUser?
    isAuthenticated: () ->
      authenticated
    getToken: () ->
      #'NgUkDb8Re1VVa8GwzKNU'
      currentUser?.token
    isGranted: (pageData) ->
      authenticated or pageData?.public is true
    current: () ->
      user = currentUser
      if !user?
        user = KeyValueRepository.get localStoragePrefix, localStorageUserKey
      if user?.login then user else
        id: 0
        login: null
        password: null
        token: null
    authenticate: () ->
      q = $q.defer()
      currentUser = u.current()
      if authenticated
        # resolve immediately as authentication has been done
        q.resolve currentUser
      else
        # credentials should be checked on the server here
        # instead we just verify we have a login and a password
        authenticated = currentUser?.login? and currentUser?.password?
        q.resolve currentUser
      q.promise
    logout: () ->
      KeyValueRepository.remove localStoragePrefix, localStorageUserKey
      currentUser = undefined
      authenticated = false

.factory 'Authorize', ($rootScope, $state, $ionicViewService, User) ->
  auth =
    authorize: () ->
      # verifies that the user is authenticated then verifies that the state can be accessed
      User.authenticate().then () ->
        if !User.isGranted($rootScope.states.toState.data)
          #$ionicViewService.clearHistory()
          $state.go 'app.login'