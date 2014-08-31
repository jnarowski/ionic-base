angular.module 'karmacrm.common.settings.company', [
  'karmacrm.common.server'
]
# Company repository
.factory 'CompanyRepository', ($q, $resource, Server) ->

  companies =
    resource: $resource(Server.getApiUrl('companies.json'),
      { },
      { find: { method : 'GET', isArray : no } }
    )

    # returns all the users as an array
    filter: (search) ->
      q = $q.defer()
      companies.resource.find({'filters[name]': search}).$promise
        .then (response) -> q.resolve response.results
      q.promise
