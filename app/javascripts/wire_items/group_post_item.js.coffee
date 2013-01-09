CommonPlace.wire_item.GroupPostWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/post-item"
  tagName: "li"
  className: "wire-item"

  events:
    "click .editlink": "editGroupPost"
    "click .thank-link": "thank"
    "click .share-link": "share"
    "click .reply-link": "reply"
    "click .flag-link": "flag"
    "click .message-link": "messageUser"
    "click .author": "showUserWire"
    "click .title": "showWireItem"
    blur: "removeFocus"

  canEdit: ->
    #CommonPlace.account.canEditGroupPost @model
    false

  editGroupPost: (e) ->
    e and e.preventDefault()
    formview = new PostFormView(
      model: @model
      template: "shared/group-post-edit-form"
    )
    formview.render()

)
