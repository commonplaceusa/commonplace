CommonPlace.wire_item.GroupProfileCard = CommonPlace.wire_item.ProfileCard.extend(
  template: "wire_items/group-card"
  tagName: "li"
  className: "profile-card"

  events:
    "click .subscribe": "subscribe"
    "click .unsubscribe": "unsubscribe"

  post_count: ->
    @model.get "post_count"

  event_count: ->
    @model.get "event_count"

  subscribers: ->
    @model.get "subscriber_count"

  isSubscribed: ->
    CommonPlace.account.isSubscribedToGroup @model

  subscribe: (e) ->
    e.preventDefault() if e
    return @showRegistration() if @isGuest()
    CommonPlace.account.subscribeToGroup @model, _.bind(->
      @render()
    , this)

  unsubscribe: (e) ->
    e.preventDefault() if e
    CommonPlace.account.unsubscribeFromGroup @model, _.bind(->
      @render()
    , this)
)
