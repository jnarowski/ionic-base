angular.module 'karmacrm.common.custom_field.date', [
]
.factory 'CustomDate', () ->
  date =
    showTemplateUrl: 'common/application/controls/customField/date/dateShow.tpl.html'
    editTemplateUrl: 'common/application/controls/customField/date/dateEdit.tpl.html'
    hasOptions: no
    parseValue: (sValue) -> # after migration to Angular 1.3: moment(sValue, 'YYYY-MM-DD').toDate()
      m = moment(sValue, 'YYYY-MM-DD')
      if m.isValid() then m.format('YYYY-MM-DD') else null
    hasValue: (customValue) -> # after migration to Angular 1.3: angular.isDate customValue.value
      moment(customValue.value, 'YYYY-MM-DD').isValid()
    defaultValue: ''