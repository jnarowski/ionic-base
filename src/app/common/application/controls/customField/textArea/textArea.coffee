angular.module 'karmacrm.common.custom_field.text_area', [
]
.factory 'CustomTextArea', () ->
  textArea =
    showTemplateUrl: 'common/application/controls/customField/textArea/textAreaShow.tpl.html'
    editTemplateUrl: 'common/application/controls/customField/textArea/textAreaEdit.tpl.html'
    hasOptions: no
    parseValue: (sValue) -> sValue
    hasValue: (customValue) -> customValue.value isnt null and customValue.value isnt ''
    defaultValue: ''