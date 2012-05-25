Home.ui.Posting = Framework.View.extend
  template: "home.posting"
  klass: "conversation"
  category: "Conversation"

  render: ->
    this.$el.html this.renderTemplate()

  show: (klass) ->
    this.klass = klass
    this.$(".help, .form-container, .links").hide()
    this.$("." + klass).show()
    this.$(".help." + klass + ".rounded_corners").hide()
    this.$(".links-" + klass).show()
    this.$(".links ." + klass).addClass "current"

  showDefault: (klass) ->
    this.$(".go-back, .form-container").hide()
    this.$("." + klass).show()
    this.$(".links ." + klass).addClass "current"

  createPost: (e) ->
    title     = this.$("[name="+this.klass+"-title]").val()
    body      = this.$("[name="+this.klass+"-post]").val()
    price     = this.$("[name="+this.klass+"-price]").val()
    date      = this.$("[name="+this.klass+"-date]").val()
    starttime = this.$("[name="+this.klass+"-starttime]").val()
    endtime   = this.$("[name="+this.klass+"-endtime]").val()
    venue     = this.$("[name="+this.klass+"-venue]").val()
    address   = this.$("[name="+this.klass+"-address]").val()
    category  = this.category

    params = 
      "title"    : title
      "body"     : body
      "price"    : price
      "date"     : date
      "starttime": starttime
      "endtime"  : endtime
      "venue"    : venue
      "address"  : address
      "category" : category 
    this.sendPost(params)

  sendPost: (data) ->
    community = router.community 
    posts = new Backbone.Collection()
    posts.url = "/api" + community.get("links").posts
    posts.create(data)
    posts.trigger("sync")

  changeCategory: ->
    category = this.$("[name='category']:checked")
    this.category = category.val()
    klass = category.parent().attr("class")
    if klass isnt undefined
      this.show(klass)

  events:
    "click button": "createPost"
    "click .links-conversation li": "changeCategory"
    "click .links-request li": "changeCategory" 
    "click .links-event li": "changeCategory" 
