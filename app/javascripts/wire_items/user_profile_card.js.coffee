CommonPlace.wire_item.UserProfileCard = CommonPlace.wire_item.ProfileCard.extend(
  template: "wire_items/user-card"
  tagName: "li"
  className: "profile-card"

  events:
    "click .message-link": "messageUser"
    "click .meet": "meet"
    "click .unmeet": "unmeet"
    "click .page-link": "showPage"

  post_count: ->
    @model.get "post_count"

  reply_count: ->
    @model.get "reply_count"

  sell_count: ->
    @model.get "sell_count"

  thank_count: ->
    @model.get "thank_count"

  met_count: ->
    @model.get "met_count"

  pages: ->
    pages = @model.get "pages"
    pages[pages.length - 1].last = true if pages and pages.length > 0
    pages

  hasPages: ->
    pages = @model.get "pages"
    pages and pages.length > 0

  hasMet: () ->
    CommonPlace.account.hasMetUser @model

  showPage: (e) ->
    e.preventDefault() if e
    page_slug = @$(e.currentTarget).attr("title")
    slug = CommonPlace.community.get("slug")

    app.showFeedPage(slug, page_slug) if page_slug

  meet: (e) ->
    e.preventDefault() if e
    CommonPlace.account.meetUser @model
    @$(".just-met").show()
    @$(".meet").hide()
    _kmq.push(['record', 'Met User', {'initiator': CommonPlace.account.id, 'recipient': @model.id}]) if _kmq?

  unmeet: (e) ->
    CommonPlace.account.unmeetUser @model, _.bind(->
      @render()
    , this)
)
