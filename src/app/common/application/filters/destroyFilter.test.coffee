describe 'PhoneListCtrl', () ->
  beforeEach ->
    module('karmacrm.common.filter')
    inject (_$filter_) ->
      this.$filter = _$filter_

  it('should filter out items having _destroy true', inject(($controller) ->
    filter = this.$filter('notDestroyed')

    items = [{name: 'Jimmy', _destroy: false}, {name: 'Bob', _destroy: 0}, {name: 'Hanna', _destroy: yes}]
    filtered = filter(items)
    expect(filtered.length).toBe(2)
    expect(filtered[0].name).toBe('Jimmy')
    expect(filtered[1].name).toBe('Bob')

    items = [{name: 'Sam', _destroy: no}, {name: 'Henry', _destroy: 'true'}, {name: 'Georg', _destroy: null}]
    filtered = filter(items)
    expect(filtered.length).toBe(2)
    expect(filtered[0].name).toBe('Sam')
    expect(filtered[1].name).toBe('Georg')
  ))