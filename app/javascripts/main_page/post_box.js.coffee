CommonPlace.main.PostBox = FormView.extend(
  template: "main_page.post-box"

  events:
    "click .navigation li": "clickTab"
    "click .close": "exit"

  afterRender: ->
    @$(".post-box").addClass "first"
    @modal.render()

  clickTab: (e) ->
    e.preventDefault()

    # DETERMINE WHAT TO DO WITH URLS WHEN WE CLICK
    @switchTab $(e.currentTarget).attr("data-tab"), e

  switchTab: (tab, e) ->
    @showTab tab

  showTab: (tab, model) ->
    view = undefined
    view = @tabs(tab, model)
    view.render()
    @$(".post-box").removeClass "first"
    @$(".links").html view.el
    @$("[placeholder]").placeholder()
    @$("input:visible:first").focus() if @browserSupportsPlaceholders() and $.browser.webkit #only focus the first input if the browser supports placeholders and is webkit based (others clear the placeholder on focus)
    CommonPlace.layout.reset()
    view.onFormFocus()  if view.onFormFocus
    if @browserSupportsPlaceholders()
      $(".chzn-select").chosen()
      $(".chzn-drop").css('width','413px')
    @modal.centerEl()  # needs to be done after the form has fully rendered otherwise it will not be centered

  tabs: (tab, model) ->
    self = this
    view = undefined
    constant =
      nothing: ->
        new CommonPlace.main.PostForm(
          model: model
          modal: self.modal
        )
      event: ->
        new CommonPlace.main.EventForm(
          model: model
          modal: self.modal
        )
      promote: ->
        new CommonPlace.main.AnnouncementForm(
          model: model
          modal: self.modal
        )
      transaction: ->
        new CommonPlace.main.TransactionForm(
          model: model
          modal: self.modal
        )
      discussion: ->
        new CommonPlace.main.PostForm(
          category: "neighborhood"
          template: "main_page.forms.post-form"
          model: model
          modal: self.modal
        )
      request: ->
        new CommonPlace.main.PostForm(
          category: "offers"
          template: "main_page.forms.question-form"
          model: model
          modal: self.modal
        )
    unless constant[tab]
      view = new CommonPlace.main.AnnouncementForm()
    else
      view = constant[tab]()
    view

  groups: ->
    CommonPlace.community.get "groups"

  feeds: ->
    CommonPlace.account.get "feeds"

  promote_header: ->
    feeds = @feeds()
    if feeds.length is 1
      return "Promote #{feeds[0].name}"
    else
      return "Promote Your Work"
)
