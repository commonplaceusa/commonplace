CommonPlace.wire_item.ReplyWireItem = CommonPlace.wire_item.WireItem.extend(
  tagName: "li"
  className: "reply-item"
  template: "wire_items/reply-item"

  afterRender: ->
    @$(".reply-body").truncate max_length: 450
    @$(".markdown p").last().append @$(".controls")

  events:
    "click .reply-message-link": "messageUser"
    "click .delete-reply": "deleteReply"
    "click .author": "showAuthorWire"
    "click .avatar-container": "showAuthorWire"
    "click .thank-reply": "thankReply"

  canEdit: ->
    CommonPlace.account.canEditReply @model

  deleteReply: (e) ->
    e.preventDefault()
    self = this
    @model.destroy()

  numThanks: ->
    @model.get("thanks").length

  hasThanked: ->
    _.any @model.get("thanks"), (thank) ->
      thank.thanker is CommonPlace.account.get("name")

  canThank: ->
    @model.get("author_id") isnt CommonPlace.account.id

  thankReply: (e) ->
    e.preventDefault()  if e
    return @showRegistration() if @isGuest()
    $.post "/api" + @model.link("thank"), @options.thankReply

  showThanks: (e) ->
    e.preventDefault()  if e
    @options.showThanks()
)
