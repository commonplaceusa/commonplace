CommonPlace.main.EventForm = CommonPlace.main.BaseForm.extend(
  template: "main_page.forms.event-form"
  className: "create-event event"

  initialize: (options) ->
    CommonPlace.main.BaseForm.prototype.initialize options
    @feeds = CommonPlace.account.get("feeds")
    @user = CommonPlace.account.get("name")
    @hasFeeds = false
    if @feeds.length > 0
      @hasFeeds = true

  afterRender: ->
    @$("input.date", @el).datepicker dateFormat: "yy-mm-dd"
    @$("input[placeholder], textarea[placeholder]").placeholder()
    @hideSpinner()

    @$("select.time").dropkick()
    self = this
    @$("input.date").bind "change", ->
      self.onFormBlur target: self.$("input.date")
    @populateFormData()

  createPost: (e) ->
    e.preventDefault()
    @showSpinner()
    @disableSubmitButton()
    self = this
    @cleanUpPlaceholders()


    data =
      title: @$("[name=title]").val()
      body: @$("[name=body]").val()
      date: @$("[name=date]").val()
      starts_at: @$("[name=start]").val()
      ends_at: @$("[name=end]").val()
      venue: @$("[name=venue]").val()
      address: @$("[name=address]").val()
      groups: @$("[name=groups]:checked").map(->
        $(this).val()
      ).toArray()

    feed_id = @$("[name=feed_selector]").val()
    if feed_id is ""
      $error = @$(".error")
      $error.html("Please choose who to post as")
      $error.show()
      @hideSpinner()
      @enableSubmitButton()
      return

    if feed_id isnt undefined and feed_id isnt "self"
      feed = new Feed({links: {self: "/feeds/" + feed_id, events: "/feeds/" + feed_id + "/events"}})
      @sendPost feed.events, data, @eventSuccess
    else
      @sendPost CommonPlace.community.events, data

  eventSuccess: ->
    CommonPlace.community.events.trigger "sync"

  groups: ->
    CommonPlace.community.get "groups"

  time_values: _.flatten(_.map(["am", "pm"], (half) ->
    _.map [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], (hour) ->
      _.map ["00", "30"], (minute) ->
        String(hour) + ":" + minute + half


  ))
)
