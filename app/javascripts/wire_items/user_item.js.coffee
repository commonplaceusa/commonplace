CommonPlace.wire_item.UserWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/user-item"
  tagName: "li"
  className: "wire-item group-member"
  initialize: (options) ->
    @attr_accessible [ "first_name", "last_name", "avatar_url" ]

  afterRender: ->
    @model.on "change", @render, this

  events:
    "click button": "messageUser"
)
