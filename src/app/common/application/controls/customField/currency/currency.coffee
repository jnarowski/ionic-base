angular.module 'karmacrm.common.custom_field.currency', [
]
.factory 'CustomCurrency', () ->
  currency =
    showTemplateUrl: 'common/application/controls/customField/currency/currencyShow.tpl.html'
    editTemplateUrl: 'common/application/controls/customField/currency/currencyEdit.tpl.html'
    hasOptions: no
    parseValue: (sValue) -> parseFloat sValue
    hasValue: (customValue) -> customValue.value isnt null
    defaultValue: null # no value at all is better than an arbitrary zero