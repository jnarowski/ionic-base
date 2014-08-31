angular.module 'karmacrm.common.filter.date', []
.filter 'shortDate', () ->
  (sDate) ->
    moment(sDate).format('lll')