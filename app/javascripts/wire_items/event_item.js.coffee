CommonPlace.wire_item.EventWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/event-item"
  tagName: "li"
  className: "wire-item"
  tabName: "event"

  monthAbbrevs: [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec" ]

  events:
    "click .wire_filter": "loadWire"
    "click .editlink": "edit"
    "click .thank-link": "thank"
    "click .flag-link": "flag"
    "click .share-link": "share"
    "click .reply-link": "reply"
    "click .message-link": "messageUser"
    "click .author": "showAuthorWire"
    "click .title": "showWireItem"
    blur: "removeFocus"

  eventDateISO: ->
    @model.get("occurs_on")

  eventDate: ->
    timeAgoInWords @eventDateISO()

  short_month_name: ->
    m = @model.get("occurs_on").match(/(\d{4})-(\d{2})-(\d{2})/)
    @monthAbbrevs[m[2] - 1]

  day_of_month: ->
    m = @model.get("occurs_on").match(/(\d{4})-(\d{2})-(\d{2})/)
    m[3]

  year_of_event: ->
    m = @model.get("occurs_on").match(/(\d{4})-(\d{2})-(\d{2})/)
    m[1]

  venue: ->
    @model.get "venue"

  address: ->
    @model.get "address"

  start_time: ->
    @model.get "starts_at"

  end_time: ->
    @model.get "ends_at"

  canEdit: ->
    CommonPlace.account.canEditEvent @model
)
