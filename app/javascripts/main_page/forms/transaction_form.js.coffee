CommonPlace.main.TransactionForm = CommonPlace.main.BaseForm.extend(
  template: "main_page.forms.transaction-form"
  className: "create-transaction transaction"

  initialize: (options) ->
    CommonPlace.main.BaseForm.prototype.initialize options
    @feeds = CommonPlace.account.get("feeds")
    @user = CommonPlace.account.get("name")
    @hasFeeds = false
    if @feeds.length > 0
      @hasFeeds = true

  afterRender: ->
    @data = {}
    @data.image_id = []
    @$("input[placeholder], textarea[placeholder]").placeholder()
    if not @isPostEdit()
      @initImageUploader(@$(".one"), 1)
      @initImageUploader(@$(".two"), 2)
      @initImageUploader(@$(".three"), 3)
    else
      @$(".item_pic").hide()
    @hideSpinner()
    self = this
    @populateFormData()

  initImageUploader: ($el, num) ->
    self = this
    @imageUploader = new AjaxUpload($el,
      action: "/api/transactions/image"
      name: "image"
      data: @data
      responseType: "text/html"
      autoSubmit: true
      onChange: ->
        self.hasImageFile = true

      onSubmit: _.bind((file, extension) ->
          $upload_pic = $(".item_pic#" + num)
          $upload_pic.attr("src", "/assets/loading.gif")
          $upload_pic.parent().addClass("loading")
        , this)

      onComplete: _.bind((file, response) ->
          response = $.parseJSON(response)
          $upload_pic = $(".item_pic#" + num)
          $upload_pic.attr("src", response.image_normal)
          $upload_pic.parent().removeClass("loading")
          @data.image_id[num-1] = response.id
        , this)
    )

  createPost: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @showSpinner()
    @disableSubmitButton()

    number = @$("[name=price]").val()
    if number.length > 0
      price = Number(number.replace(/[^0-9\.]+/g, "") * 100).toFixed(2)
    @data.title = @$("[name=title]").val()
    @data.price = price
    @data.body = @$("[name=body]").val()

    feed_id = @$("[name=feed_selector]").val()
    if feed_id is ""
      @showError "Please choose who to post as"
      @hideSpinner()
      @enableSubmitButton()
      return

    if feed_id isnt undefined and feed_id isnt "self"
      feed = new Feed({links: {self: "/feeds/" + feed_id, transactions: "/feeds/" + feed_id + "/transactions"}})
      @sendPost feed.transactions, @data
    else
      @sendPost CommonPlace.community.transactions, @data

  sendPost: (transactionCollection, data) ->
    self = this
    if @isPostEdit()
      for key, value of data
        @model.set(key, value)
      @model.save()
      @exit()
    else
      transactionCollection.create data,
        success: _.bind((post) ->
          if self.hasImageFile
            self.addImageToPost(post)
          self.render()
          CommonPlace.community.transactions.trigger "sync"
          @showShareModal(post, "Thanks for posting!", "You've just shared this post with #{@getUserCount()} neighbors in #{@community_name()}. Share with some more people!")
          _kmq.push(['record', 'Post', {'Schema': post.get("schema"), 'ID': post.id}]) if _kmq?
        , this)

        error: (attribs, response) ->
          _kmq.push(['record', 'Post Error', {'Attributes': attribs}]) if _kmq?
          self.enableSubmitButton()
          self.showError response.responseText

  addImageToPost: (post) ->
    $.ajax(
      type: "POST"
      url: "/api" + post.get("links").self + "/add_image"
      data:
        "image_id" : post.get("image_id")
      success: (response) ->
      dataType: "JSON"
    )
)
