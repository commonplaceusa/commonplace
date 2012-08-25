CommonPlace.main.SubscribeView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.subscribe"
  feed_kinds: [ "Non-profit", "Community Group", "Business", "Municipal", "News", "Other" ]
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click .next-button": "submit"

  afterRender: ->
    self = this
    feeds = @community.featuredFeeds
    feeds.fetch(
      success: ->
        $ul = self.$("ul.feeds_container")
        _.each feeds.models, _.bind((feed) ->
          itemView = new self.FeedItem(model: feed)
          itemView.render()
          category = "#" + self.feed_kinds[feed.get("kind")]
          $(category).append itemView.el
        , this)
    )
    @slideIn @el

  community_name: ->
    @community.get("name")

  categories: ->
    @feed_kinds

  submit: (e) ->
    e.preventDefault()  if e
    feeds = _.map(@$("input[name=feeds_list]:checked"), (feed) ->
      $(feed).val()
    )
    if _.isEmpty(feeds)
      @finish()
    else
      CommonPlace.account.subscribeToFeed feeds, _.bind(->
        @finish()
      , this)

  finish: ->
    #@nextPage "neighbors", @data
    window.location.pathname = "/" + @community.get("slug")

  FeedItem: CommonPlace.View.extend(
    template: "main_page.tour.feed-item"

    events:
      click: "check"

    initialize: (options) ->
      @model = options.model

    avatar_url: ->
      @model.get("avatar_url")

    feed_id: ->
      @model.get("id")

    feed_name: ->
      @model.get("name")

    feed_about: ->
      @model.get("about")

    check: (e) ->
      e.preventDefault()  if e
      $checkbox = @$("input[type=checkbox]")
      if $checkbox.attr("checked")
        $checkbox.removeAttr "checked"
        @$(".check").removeClass "checked"
      else
        $checkbox.attr "checked", "checked"
        @$(".check").addClass "checked"
  )
)
