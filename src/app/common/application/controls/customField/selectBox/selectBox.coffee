angular.module 'karmacrm.common.custom_field.select_box', [
]
.factory 'CustomSelectBox', () ->
  selectBox =
    showTemplateUrl: 'common/application/controls/customField/selectBox/selectBoxShow.tpl.html'
    editTemplateUrl: 'common/application/controls/customField/selectBox/selectBoxEdit.tpl.html'
    hasOptions: yes
    parseValue: (sValue) -> parseInt sValue, 10
    hasValue: (customValue) -> customValue.value and customValue.value isnt ''