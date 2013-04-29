CommonPlace.wire_item.AnnouncementWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/announcement-item"
  tagName: "li"
  className: "wire-item"
  tabName: "promote"

  events:
    "click .wire_filter": "loadWire"
    "click .editlink": "edit"
    "click .thank-link": "thank"
    "click .flag-link": "flag"
    "click .share-link": "share"
    "click .reply-link": "reply"
    "click .message-link": "messageUser"
    "click .author": "showAuthorWire"
    "click .avatar-container": "showAuthorWire"
    "click .title": "showWireItem"

  canEdit: ->
    CommonPlace.account.canEditAnnouncement @model
)
