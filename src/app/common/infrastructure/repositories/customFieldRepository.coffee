angular.module 'karmacrm.common.settings.custom_field', [
  'karmacrm.common.custom_field.select_box',
  'karmacrm.common.custom_field.check_boxes',
  'karmacrm.common.custom_field.text_area',
  'karmacrm.common.custom_field.input',
  'karmacrm.common.custom_field.date',
  'karmacrm.common.custom_field.currency'
]
# Custom field types repository
.factory 'CustomFieldTypesRepository', (SettingsRepository, CustomSelectBox, CustomCheckBoxes, CustomTextArea, CustomInput, CustomDate, CustomCurrency) ->
  custom =
    # cache the fields in memory
    _all: SettingsRepository.get('field_types').results
    
    # returns all the fields as an array
    all: () -> custom._all

    types:
      SELECT_BOX: 2
      CHECKBOXES: 3
      TEXT_AREA: 4
      TEXT_FIELD: 5
      HEADING: 6
      DATE: 7
      CURRENCY: 8
      AUTO_INCREMENT: 9
      INTEGER: 10

    get: (typeId) ->
      _.find(custom._all, (ft) -> ft.field_type_id == typeId)
    
    getEntity: (typeId) ->
      fieldEntity = null
      switch typeId
        when custom.types.SELECT_BOX then fieldEntity = CustomSelectBox
        when custom.types.CHECKBOXES then fieldEntity = CustomCheckBoxes
        when custom.types.TEXT_AREA then fieldEntity = CustomTextArea
        when custom.types.TEXT_FIELD then fieldEntity = CustomInput
        when custom.types.DATE then fieldEntity = CustomDate
        when custom.types.CURRENCY then fieldEntity = CustomCurrency
      fieldEntity

.factory 'CustomFieldRepository', (SettingsRepository, CustomFieldTypesRepository) ->
  init = () ->
    allFields = SettingsRepository.get('fields').results
    
    # filter out field options also present in 'fields' list, recognizable by their parent_id value
    allFields = _.filter(allFields, (field) -> field.parent_id is null)

    # add the default options for the fields that need them
    for field in allFields
      if field.field_type_id in [CustomFieldTypesRepository.types.SELECT_BOX] # TODO: move this into each custom field
        fieldType = CustomFieldTypesRepository.get field.field_type_id
        field.options.splice(0, 0, fieldType.defaultOptions[0]) if fieldType?.defaultOptions?.length

    return allFields

  getSingleValueName = (customValue, value) ->
    option = _.find(customValue.customField.options, (o) -> o.id is value)
    option?.name

  custom =
    # cache the fields in memory
    _all: init()
    
    # returns all the fields as an array
    all: () -> custom._all

    # returns a string representing the field value intended for display. For example replaces field integer value with its matching option label.
    getDisplayValue: (customValue) ->
      if customValue.fieldEntity.hasOptions
        if customValue.fieldEntity.multiSelect
          _.map(customValue.values, (value) -> getSingleValueName(customValue, value)).join(', ')
        else
          getSingleValueName(customValue, customValue.value)
      else
        customValue.value
