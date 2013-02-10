CommonPlace.wire_item.FeedProfileCard = CommonPlace.wire_item.ProfileCard.extend(
  template: "wire_items/feed-card"
  tagName: "li"
  className: "profile-card"

  events:
    "click .message-link": "messageUser"
    "click .subscribe": "subscribe"
    "click .unsubscribe": "unsubscribe"

  site_url: ->
    @model.get "website"

  announce_count: ->
    @model.get "announcement_count"

  event_count: ->
    @model.get "event_count"

  subscribers: ->
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
)
