CommonPlace.main.SubscribeView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.subscribe"
  feed_kinds: [ "communitygroup", "communitygroup", "business", "municipal", "news", "communitygroup" ]
  feed_categories: [ {name: "Community Group", id:"communitygroup"}, {name:"Municipal", id:"municipal"}, {name:"News", id:"name"}, {name:"Discussion", id:"discussion"}, {name:"Business", id:"business"} ]
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click .next-button": "submit"

  afterRender: ->
    self = this
    @$(".page_category").hide()
    groups = @community.groups
    groups.fetch(
      success: ->
        _.each groups.models, _.bind((group) ->
          itemView = new self.GroupItem(model: group)
          itemView.render()
          $(".discussion").append itemView.el
          $("#discussion").show()
        , this)
    )
    feeds = @community.feeds
    feeds.fetch(
      success: ->
        _.each feeds.models, _.bind((feed) ->
          itemView = new self.FeedItem(model: feed)
          itemView.render()
          category = self.feed_kinds[feed.get("kind")]
          $("." + category).append itemView.el
          $("#" + category).show()
        , this)
    )
    @fadeIn @el

  community_name: ->
    @community.get("name")

  categories: ->
    @feed_categories

  submit: (e) ->
    e.preventDefault()  if e
    feeds = _.map(@$("input[name=feeds_list]:checked"), (feed) ->
      $(feed).val()
    )
    if not _.isEmpty(feeds)
      CommonPlace.account.subscribeToFeed feeds

    groups = _.map(@$("input[name=groups_list]:checked"), (group) ->
      $(group).val()
    )
    if not _.isEmpty(groups)
      CommonPlace.account.subscribeToGroup groups

    @finish()

  finish: ->
    @nextPage "rules", @data

  FeedItem: CommonPlace.View.extend(
    className: "page_item"
    template: "main_page.tour.feed-item"

    events:
      click: "check"

    initialize: (options) ->
      @model = options.model

    afterRender: ->
      @$(".avatar-container").css("background-size": "cover")

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

  GroupItem: CommonPlace.View.extend(
    className: "page_item"
    template: "main_page.tour.group-item"

    events:
      click: "check"

    initialize: (options) ->
      @model = options.model

    afterRender: ->
      @$(".avatar-container").css("background-size": "cover")

    avatar_url: ->
      @model.get("avatar_url")

    group_id: ->
      @model.get("id")

    group_name: ->
      @model.get("name")

    group_about: ->
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
