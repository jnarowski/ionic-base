angular.module 'karmacrm.common.custom_field.input', [
]
.factory 'CustomInput', () ->
  selectBox =
    showTemplateUrl: 'common/application/controls/customField/input/inputShow.tpl.html'
    editTemplateUrl: 'common/application/controls/customField/input/inputEdit.tpl.html'
    hasOptions: no
    parseValue: (sValue) -> sValue
    hasValue: (customValue) -> customValue.value isnt null and customValue.value isnt ''
    defaultValue: ''