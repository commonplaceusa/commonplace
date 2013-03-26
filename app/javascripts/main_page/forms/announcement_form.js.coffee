CommonPlace.main.AnnouncementForm = CommonPlace.main.BaseForm.extend(
  template: "main_page.forms.announcement-form"
  className: "create-announcement post"

  initialize: (options) ->
    CommonPlace.main.BaseForm.prototype.initialize options
    @feeds = CommonPlace.account.get("feeds")

    @hasFeeds = false
    if @feeds.length > 0
      @hasFeeds = true

    @hasBusinessFeeds = false
    for f in @feeds
      if f.kind == 2
        @hasBusinessFeeds = true

  createPost: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @showSpinner()
    @disableSubmitButton()
    @$("error").hide()

    feed_id = @$("[name=feed_selector]").val()
    if feed_id isnt undefined and feed_id isnt ""
      feed = new Feed({links: {self: "/feeds/" + feed_id, announcements: "/feeds/" + feed_id + "/announcements"}})
      data =
        title: @$("[name=title]").val()
        body: @$("[name=body]").val()

      @sendPost feed.announcements, data, @announcementSuccess
    else
      # Show an error message to select a feed
      @showError "Please select an organization to promote"
      @hideSpinner()
      @enableSubmitButton()

  name: ->
    @feed.get "name"

  announcementSuccess: ->
    CommonPlace.community.announcements.trigger "sync"
)
