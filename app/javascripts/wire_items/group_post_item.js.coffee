CommonPlace.wire_item.GroupPostWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/post-item"
  tagName: "li"
  className: "wire-item"
  tabName: "discussion"

  events:
    "click .editlink": "edit"
    "click .thank-link": "thank"
    "click .share-link": "share"
    "click .reply-link": "reply"
    "click .flag-link": "flag"
    "click .message-link": "messageUser"
    "click .author": "showUserWire"
    "click .title": "showWireItem"
    blur: "removeFocus"

  canEdit: ->
    CommonPlace.account.canEditGroupPost @model
)
