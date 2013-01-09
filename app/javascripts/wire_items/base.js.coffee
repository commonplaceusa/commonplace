CommonPlace.wire_item.WireItem = CommonPlace.View.extend(
  category: "Neighborhood Post"

  initialize: (options) ->
    self = this
    @model.on "destroy", ->
      self.remove()

  afterRender: ->
    @model.on "change", @render, this
    @reply() if @model.get("replies") isnt undefined
    @checkThanked()
    @checkFlagged()

  checkThanked: ->
    if @thanked()
      @$(".thank-link").html "Thanked!"
      @$(".thank-link").addClass "thanked-post"

  thanked: ->
    thanks = _.map(@directThanks(), (thank) ->
      thank.thanker
    )
    _.include thanks, CommonPlace.account.get("name")

  directThanks: ->
    _.filter @model.get("thanks"), (t) ->
      t.thankable_type isnt "Reply"

  thank: ->
    @$(".thank-share .current").removeClass "current"
    return @showThanks()  if @thanked()
    _kmq.push(['record', 'Thanked Post', {'Schema': @model.get("schema"), 'ID': @model.id}]) if _kmq?
    $.post "/api" + @model.link("thank"), _.bind((response) ->
      @model.set response
      @render()
      @showThanks()
    , this)

  showThanks: (e) ->
    e.preventDefault()  if e
    unless _.isEmpty(@model.get("thanks"))
      @removeFocus()
      @$(".thank-link").addClass "current"
      @$(".replies-area").empty()
      thanksView = new ThanksListView(
        model: @model
      )
      thanksView.render()
      @$(".replies-area").append thanksView.el
      @state = "thanks"

  checkFlagged: ->
    if @flagged()
      @$(".flag-link").html "Flagged!"
      @$(".flag-link").addClass "flagged-post"

  flagged: ->
    flags = _.map(@directFlags(), (flag) ->
      flag.warner
    )
    _.include flags, CommonPlace.account.get("name")

  directFlags: ->
    _.filter @model.get("flags"), (t) ->
      t.warnable_type isnt "Reply"

  flag: ->
    return @showFlags() if @flagged()
    _kmq.push(['record', 'Flagged Post', {'Schema': @model.get("schema"), 'ID': @model.id}]) if _kmq?
    $.post "/api" + @model.link("flag"), _.bind((response) ->
      @model.set response
      @render()
      @showFlags()
    , this)

  showFlags: (e) ->
    e.preventDefault()  if e
    unless _.isEmpty(@model.get("flags"))
      @removeFocus()
      @$(".flag-link").addClass "current"
      @state = "flags"

  share: (e) ->
    e.preventDefault()  if e
    @state = "share"
    @removeFocus()
    $("#modal").empty()
    @$(".share-link").addClass "current"
    _kmq.push(['record', 'Clicked Share', {'Schema': @model.get("schema"), 'ID': @model.id}]) if _kmq?
    shareModal = new CommonPlace.views.ShareModal(
      model: @model
    )
    shareModal.set_header "Share this post!"
    shareModal.render()

  reply: (e) ->
    e.preventDefault()  if e
    isFirst = _.isEmpty(@repliesView)
    if @state isnt "reply" or isFirst
      @removeFocus()
      @$(".reply-link").addClass "current"
      @$(".replies-area").empty()
      @repliesView = new RepliesView(
        collection: @model.replies()
        thankReply: _.bind((response) ->
          @model.set response
        , this)
        showThanks: _.bind(->
          @showThanks()
        , this)
      )
      @repliesView.collection.on "change", _.bind(->
        @render()
      , this)
      @repliesView.render()
      @$(".replies-area").append @repliesView.el
    unless isFirst
      @$(".reply-text-entry").focus() if $.fn.placeholder.input #only focus on the reply box if the browser supports placeholders
      @state = "reply"

  messageUser: (e) ->
    e.preventDefault() if e
    if @model.get("owner_type") is "Feed"
      recipient = new Feed(links:
        self: @model.link("author")
      )
    else
      recipient = new User(links:
        self: @model.link("author")
      )

    recipient.fetch
      success: _.bind(->
        subject = ""
        if @model.get("title")
          subject = "Re: " + @model.get("title")
        else if @model.get("body")
          subject = "Re: " + @model.get("body")
        formview = new MessageFormView(model: new Message(messagable: recipient), subject: subject)
        formview.render()
      ,this)

  showWireItem: (e) ->
    e.preventDefault() if e
    schema = @model.get("schema")
    if schema is "posts"
      app.showPost(CommonPlace.community.get("slug"), @model.get("id"))
    else if schema is "transactions"
      app.showTransaction(CommonPlace.community.get("slug"), @model.get("id"))
    else if schema is "events"
      app.showEvent(CommonPlace.community.get("slug"), @model.get("id"))
    else if schema is "group_posts"
      app.showGroupPost(CommonPlace.community.get("slug"), @model.get("id"))
    else if schema is "announcements"
      app.showAnnouncement(CommonPlace.community.get("slug"), @model.get("id"))

  showAuthorWire: (e) ->
    e.preventDefault() if e
    if @isFeed()
      @showFeedWire()
    else
      @showUserWire()

  showUserWire: (e) ->
    e.preventDefault() if e
    app.showUserWire(CommonPlace.community.get("slug"), @model.get("user_id"))

  showFeedWire: (e) ->
    e.preventDefault() if e
    app.showFeedPage(CommonPlace.community.get("slug"), @model.get("feed_id"))

  removeFocus: ->
    @$(".thank-share .current").removeClass "current"

  publishedAt: ->
    timeAgoInWords @model.get("published_at")

  publishedAtISO: ->
    @model.get "published_at"

  avatarUrl: ->
    @model.get "avatar_url"

  author_url: ->
    '/' + CommonPlace.community.get("slug") + '/show' + @model.get("links").author

  share_url: ->
    CommonPlace.community.get("links")["base"] + "/show/" + @model.get("schema") + "/" + @model.get("id")

  hasImages: ->
    if @model.get("images").length > 0
      return true
    else
      return false

  images: ->
    @model.get "images"

  title: ->
    @model.get "title"

  author: ->
    @model.get "author"

  first_name: ->
    @model.get "first_name"

  body: ->
    @model.get "body"

  numThanks: ->
    @directThanks().length

  hasThanks: ->
    @numThanks() > 0

  peoplePerson: ->
    (if (@numThanks() is 1) then "person" else "people")

  wireCategory: ->
    schema = @model.get("schema")
    category = @model.get "category"
    if category
      if category is "offers"
        category = "question"
      category
    else
      if schema is "transactions"
        "marketplace"
      else if schema is "group_posts"
        @model.get("group")
      else
        if schema.substring(schema.length - 1, schema.length)
          schema.substring(0, schema.length - 1) #remove the trailing "s" from the schema
        else
          schema

  wireCategoryClass: ->
    category = @wireCategory()
    if category
      #Replace ampersands with "and" and spaces with "-" because they are not valid class characters
      category = category.replace /&/g, "and"
      category = category.replace /\s{1,}/g, "-"
      category.toLowerCase()
    else
      category = "post"

  wireCategoryName: ->
    category = @wireCategory()
    if category
      category = category.split(' ')
      for key,word of category
        category[key] = @first_letter_caps word
      category.join(' ')
    else
      @first_letter_caps @category

  first_letter_caps: (word) ->
    word.charAt(0).toUpperCase() + word.substr(1,word.length-1).toLowerCase()

  isFeed: ->
    @model.get("owner_type") is "Feed"

  feedUrl: ->
    '/' + CommonPlace.community.get("slug") + @model.get "feed_url"
)
