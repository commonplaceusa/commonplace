CommonPlace.wire_item.FeedProfileCard = CommonPlace.wire_item.ProfileCard.extend(
  template: "wire_items/feed-card"
  tagName: "li"
  className: "profile-card"

  initialize: ->
    @modal = new ModalView({form: this.el});

  events:
    "click .editlink": "edit"
    "click .message-link": "messageUser"
    "click .subscribe": "subscribe"
    "click .unsubscribe": "unsubscribe"
    "click .subscribers": "showSubscribers"
    "click .announcements": "showAnnouncements"
    "click .transaction": "openTransactionForm"

  showAnnouncements: ->
    slug = CommonPlace.community.get("slug")
    id = @model.get("id")
    app.showFeedPage(slug, id)

  showSubscribers: ->
    slug = CommonPlace.community.get("slug")
    id = @model.get("id")
    app.showFeedSubscribers(slug, id)

  canEdit: ->
    CommonPlace.account.canEditFeed @model

  edit: (e) ->
    e.preventDefault() if e
    formview = new FeedEditFormView({
      model: @model
    })
    formview.render()

  site_url: ->
    @model.get "website"

  announce_count: ->
    @model.get "announcement_count"

  event_count: ->
    @model.get "event_count"

  subscribers_count: ->
    @model.get "subscriber_count"

  isSubscribed: ->
    CommonPlace.account.isSubscribedToFeed @model

  isOwner: ->
    CommonPlace.account.isFeedOwner @model

  subscribe: (e) ->
    e.preventDefault() if e
    CommonPlace.account.subscribeToFeed @model, _.bind(->
      @render()
    , this)

  unsubscribe: (e) ->
    e.preventDefault() if e
    CommonPlace.account.unsubscribeFromFeed @model, _.bind(->
      @render()
    , this)

  openTransactionForm: (e)->
    e.preventDefault()
    postbox = new CommonPlace.main.PostBox
      account: CommonPlace.account
      community: CommonPlace.community
    postbox.render()
    postbox.showTab("transaction", @model)
)
