CommonPlace.wire_item.AnnouncementWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/announcement-item"
  tagName: "li"
  className: "wire-item"

  events:
    "click .editlink": "editAnnouncement"
    "click .thank-link": "thank"
    "click .flag-link": "flag"
    "click .share-link": "share"
    "click .reply-link": "reply"
    "click .message-link": "messageUser"
    "click .author": "showAuthorWire"
    "click .title": "showWireItem"
    blur: "removeFocus"

  canEdit: ->
    #CommonPlace.account.canEditAnnouncement @model
    false

  editAnnouncement: (e) ->
    e.preventDefault()  if e
    formview = new CommonPlace.main.AnnouncementForm(
      model: @model
      template: "shared/announcement-edit-form"
    )
    formview.render()
)
