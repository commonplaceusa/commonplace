CommonPlace.wire_item.MessageWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "inbox/message"
  tagName: "li"
  className: "message-item"
  events:
    "click a.person": "sendMessageToUser"

  afterRender: ->
    @repliesView = {}
    @reply()
    @model.on "change", @render, this

  avatarUrl: ->
    @model.get "avatar_url"

  date: ->
    timeAgoInWords @model.get("published_at")

  title: ->
    @model.get "title"

  author: ->
    @model.get "author"

  recipient: ->
    @model.get "user"

  message_id: ->
    @model.get "id"

  body: ->
    @model.get "body"

  sendMessageToUser: (e) ->
    e and e.preventDefault()
    user = new User(links:
      self: @model.link((if @isSent() then "user" else "author"))
    )
    user.fetch success: ->
      formview = new MessageFormView(model: new Message(messagable: user))
      formview.render()

  feedUrl: ->
    self = this
    feed = new Feed(links:
      self: @model.link("user")
    )
    feed.fetch success: ->
      self.$(".messagable.feed").attr "href", feed.get("url")

  isFeed: ->
    @model.get("type") is "Feed"

  isSent: ->
    @model.get("author_id") is CommonPlace.account.id
)
