angular.module 'karmacrm.common.settings.email', []
# Email types repository
.factory 'EmailTypesRepository', () ->
  emailTypes =
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

    # returns all the email types as an array
    all: () -> emailTypes._all
    
    getName: (id) ->
      _.find(emailTypes._all, (emailType) -> emailType.id == id)?.name ? ''
    
    # ID to use when a new email is inserted
    defaultId: 1

.factory 'EmailEntity', (EmailTypesRepository) ->
  entity =
    name: 'Email'
    isEmpty: (email) -> email.email.length is 0
    createEmpty: ->
      secondary_email_type_id: EmailTypesRepository.defaultId
      email: ''