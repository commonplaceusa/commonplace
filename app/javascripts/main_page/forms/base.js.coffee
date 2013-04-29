CommonPlace.main.BaseForm = CommonPlace.View.extend(
  tagName: "form"
  className: "create-neighborhood-post post"
  category: "neighborhood"
  events:
    "click .submit": "createPost"
    "focusin input, textarea": "onFormFocus"
    "keydown textarea": "resetLayout"
    "focusout input, textarea": "onFormBlur"
    "click .back": "showPostbox"
    "click .delete": "deletePost"
    "click .transaction": "openTransactionForm"
    "click #new_feed_button": "createFeed"

  initialize: (options) ->
    if options
      @template = options.template or @template if options.template
      @category = options.category or @category if options.category
      if options.model
        @model = options.model
      else
        @model = undefined
      @modal = options.modal if options.modal

  afterRender: ->
    @$("input[placeholder], textarea[placeholder]").placeholder()
    @hideSpinner()
    @populateFormData()

  populateFormData: ->
    if @isPostEdit()
      group_id = @model.get("group_id")
      feed_id = @model.get("feed_id")
      @$("[name=title]").val(@model.get("title")) if @model.get("title")
      @$("[name=body]").val(@model.get("body")) if @model.get("body")
      if group_id
        @$('"[value=' + group_id + ']"').attr("selected", "selected")
        @$("[name='group_selector']").attr("disabled", "disabled")
      if feed_id
        @$('"[value=' + feed_id + ']"').attr("selected", "selected")
        @$("[name='feed_selector']").attr("disabled", "disabled")

      @$("[name=date]").val(@model.get("date").split("T")[0]) if @model.get("date")
      @$("[name=venue]").val(@model.get("venue")) if @model.get("venue")
      @$("[name=address]").val(@model.get("address")) if @model.get("address")
      @$(".starting_times[value='" + @model.get("starts_at").trim() + "']").attr("selected", "selected") if @model.get("starts_at")
      @$(".ending_times[value='" + @model.get("ends_at").trim() + "']").attr("selected", "selected") if @model.get("ends_at")
      @$("[name=price]").val(@model.get("price")/100) if @model.get("price")
      images = @model.get("images")
      @$(".item_pic").attr("src", images[0].image_url) if images and images[0]
      @$(".chzn-select").trigger("liszt:updated")

  isPostEdit: ->
    if @model
      return true
    else
      return false

  deletePost: ->
    if @isPostEdit()
      @model.destroy()
      @exit()

  showSpinner: ->
    @$(".spinner").show()

  hideSpinner: ->
    @$(".spinner").hide()

  enableSubmitButton: ->
    @$(".submit").removeAttr "disabled"

  disableSubmitButton: ->
    @$(".submit").attr "disabled", "disabled"

  createFeed: (e) ->
    e.preventDefault() if e
    @showFeedCreationForm()
    @exit()

  createPost: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @showSpinner()
    @disableSubmitButton()

    # Category not specified
    if @options.category is `undefined`

      # Show a notification
      @showError "Please select a category"
      @hideSpinner()
      @enableSubmitButton()
    else
      data =
        title: @$("[name=title]").val()
        body: @$("[name=body]").val()
        category: @$("[name=categorize]").val()

      @sendPost CommonPlace.community.posts, data

  sendPost: (collection, data, callback) ->
    self = this
    if @isPostEdit()
      for key, value of data
        @model.set(key, value)
      @model.save()
      @exit()
    else
      collection.create data,
        success: _.bind((post) ->
          collection.trigger "sync"
          self.render()
          self.resetLayout()
          _kmq.push(['record', 'Post', {'Schema': post.get("schema"), 'ID': post.id}]) if _kmq?
          @showShareModal(post, "Thanks for posting!", "You've just shared this post with #{@getUserCount()} neighbors in #{@community_name()}. Share with some more people!")
          callback() if callback
        , this)

        error: (attribs, response) ->
          _kmq.push(['record', 'Post Error', {'Attributes': attribs}]) if _kmq?
          self.hideSpinner()
          self.enableSubmitButton()
          self.showError response.responseText

  exit: ->
    @modal.exit() if @modal

  getUserCount: () ->
    CommonPlace.community.get("user_count")

  showShareModal: (model, header, message) ->
    shareModal = new CommonPlace.views.ShareModal(
      model: model
    )
    shareModal.set_header header
    shareModal.set_message message
    shareModal.render()

  showPostbox: (e) ->
    e.preventDefault() if e
    postbox = new CommonPlace.main.PostBox
      account: CommonPlace.account
      community: CommonPlace.community
    postbox.render()

  showError: (message) ->
    @$(".error").text message
    @$(".error").show()

  onFormFocus: ->
    $moreInputs = @$(".on-focus")
    unless $moreInputs.is(":visible")
      naturalHeight = $moreInputs.actual("height")
      $moreInputs.css height: 0
      $moreInputs.show()

      CommonPlace.layout.reset()

  onFormBlur: (e) ->
    $("#invalid_post_tooltip").hide()
    unless @focused
      @$(".on-focus").hide()
      @resetLayout()
    if not $(e.target).val() or $(e.target).val() is $(e.target).attr("placeholder")
      $(e.target).removeClass "filled"
    else
      $(e.target).addClass "filled"

  resetLayout: ->
    CommonPlace.layout.reset()

  hideLabel: (e) ->
    $("option.label", e.target).hide()

  openTransactionForm: (e)->
    e.preventDefault()
    postbox = new CommonPlace.main.PostBox
      account: CommonPlace.account
      community: CommonPlace.community
    postbox.render()
    postbox.showTab("transaction")
)
