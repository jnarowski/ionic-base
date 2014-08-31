angular.module 'karmacrm.common.custom_field', [
  'karmacrm.common.settings.custom_field',
  'karmacrm.common.selector'
]
.directive 'customFieldValue', (CustomFieldRepository, $compile, $templateCache) ->
  v =
    restrict: 'E'
    link: (scope, element, attrs) ->
      fieldEntity = scope.customValue.fieldEntity

      if fieldEntity
        template = $templateCache.get fieldEntity.showTemplateUrl
      else
        template = '<div>Not supported field type ' + scope.customValue.customField.field_type_id + '</div>'
      element.replaceWith($compile(template)(scope))

      scope.getName = () -> scope.customValue.customField.name
      scope.getValue = () -> CustomFieldRepository.getDisplayValue scope.customValue
      scope.getSetting1 = () -> scope.customValue.customField.setting_1

    scope:
      customValue: '='

.directive 'customFieldEdit', (CustomFieldTypesRepository, CustomFieldRepository, Selector, $compile, $templateCache) ->
  v =
    restrict: 'E'
    link: (scope, element, attrs) ->
      fieldEntity = scope.customValue.fieldEntity

      if fieldEntity
        template = $templateCache.get fieldEntity.editTemplateUrl
      else
        template = '<div>Not supported field type ' + scope.customValue.customField.field_type_id + '</div>'
      element.replaceWith($compile(template)(scope))

      scope.getName = () -> scope.customValue.customField.name
      scope.getValue = () -> CustomFieldRepository.getDisplayValue scope.customValue
      scope.getSetting1 = () -> scope.customValue.customField.setting_1

      saveValue = (value) ->
        if scope.customValue.fieldEntity.hasOptions # get the selected options IDs
          if scope.customValue.fieldEntity.multiSelect then scope.customValue.values = _.pluck(value, 'id') else scope.customValue.value = value.id
        else
          scope.customValue.value = value

      scope.selectValue = () ->
        selected = if scope.customValue.fieldEntity.hasOptions and scope.customValue.fieldEntity.multiSelect then scope.customValue.values else scope.customValue.value

        Selector.show
          selected: selected
          items: scope.customValue.customField.options
          multiSelect: scope.customValue.fieldEntity.multiSelect
        .then (value) -> saveValue value
    scope:
      customValue: '='
