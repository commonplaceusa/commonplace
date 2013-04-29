CommonPlace.main.ProfileView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.profile"
  upcoming_page: "subscribe"
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click img.facebook": "facebook"
    "click .next-button": "submit"

  afterRender: ->
    @hideSpinner()
    @hasAvatarFile = false
    @$('input[placeholder], textarea[placeholder]').placeholder()
    @initAvatarUploader @$(".avatar_file_browse")  unless CommonPlace.account.get("facebook_user")
    @form_name().val(CommonPlace.account.get("name"))
    @form_about().val(CommonPlace.account.get("about"))
    @form_orgs().val(CommonPlace.account.get("organizations"))
    @$(".profile_pic").attr("src", @avatar_url()) if @avatar_url()
    unless @current
      @fadeIn @el
      @current = true
    @$("select.list").chosen().change {}, ->
      clickable = $(this).parent("li").children("div").children("ul")
      clickable.click()

  submit: (e) ->
    self = this
    e.preventDefault()  if e
    data =
      name: @form_name().val()
      about: @form_about().val()
      organizations: @form_orgs().val()
    if @$("input:checked").attr("id") is "yes"
      @upcoming_page = "create_page"

    @showSpinner()
    CommonPlace.account.save(data,
      success: (response) ->
        self.nextPage self.upcoming_page, undefined
    )

  initAvatarUploader: ($el) ->
    self = this
    @avatarUploader = new AjaxUpload($el,
      action: "/api" + CommonPlace.community.get("links").registration.avatar
      name: "avatar"
      data: {}
      responseType: "json"
      autoSubmit: true
      onChange: ->
        self.toggleAvatar()

      onSubmit: (file, extension) ->

      onComplete: _.bind((file, response) ->
          CommonPlace.account = new Account(response)
          $(".profile_pic").attr("src", @avatar_url())
        , this)
    )

  form_name: ->
    @$("input[name=name]")

  form_orgs: ->
    @$("input[name=organizations]")

  form_about: ->
    @$("textarea[name=about]")

  toggleAvatar: ->
    @hasAvatarFile = true
    @$("a.avatar_file_browse").html "Photo Added! ✓"

  facebook: (e) ->
    e.preventDefault()  if e
    facebook_connect_avatar success: _.bind((data) ->
      CommonPlace.account.set("facebook_user", true)
      CommonPlace.account = _.extend(CommonPlace.account, data)
      @toggleAvatar()
      $(".profile_pic").attr("src", @avatar_url())
      CommonPlace.account.save()
    , this) if not CommonPlace.account.get("facebook_user")

)
