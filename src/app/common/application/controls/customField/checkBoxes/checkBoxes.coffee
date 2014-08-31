angular.module 'karmacrm.common.custom_field.check_boxes', [
]
.factory 'CustomCheckBoxes', () ->
  checkBoxes =
    showTemplateUrl: 'common/application/controls/customField/checkBoxes/checkBoxesShow.tpl.html'
    editTemplateUrl: 'common/application/controls/customField/checkBoxes/checkBoxesEdit.tpl.html'
    hasOptions: yes
    multiSelect: yes
    parseValue: (sValue) -> parseInt sValue, 10
    hasValue: (customValue) -> customValue.values.length > 0 # checkBoxes field has a value if at least one box is checked