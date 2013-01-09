CommonPlace.wire_item.GroupWireItem = CommonPlace.wire_item.WireItem.extend(
  #this is line-for-line the same as feed_item todo:DRY
  template: "wire_items/feed-item"
  tagName: "li"
  className: "wire-item feed"
  initialize: ->
    CommonPlace.account.on "change", @render, this
    @attr_accessible [ "name", "url", "avatar_url" ]

  events:
    "click button.subscribe": "subscribe"
    "click button.unsubscribe": "unsubscribe"

  subscribe: ->
    CommonPlace.account.subscribeToFeed @model

  unsubscribe: ->
    CommonPlace.account.unsubscribeFromFeed @model

  isSubscribed: ->
    CommonPlace.account.isSubscribedToFeed @model
)
