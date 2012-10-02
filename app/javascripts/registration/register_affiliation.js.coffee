CommonPlace.registration.AffiliationView = CommonPlace.registration.RegistrationModalPage.extend(
  template: "registration.affiliation"
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click .next-button": "submit"

  afterRender: ->
    @hasAvatarFile = false
    @$("select.dk").dropkick()
    $("#current-registration-page").html @el
    @$("input[placeholder]").placeholder()

  user_name: ->
    (if (@data.full_name) then @data.full_name.split(" ")[0] else "")

  submit: (e) ->
    e.preventDefault()  if e
    @$(".error").hide()
    @data.referral_source = @$("select[name=affiliation]").val()
    @data.address = @data.referral_source
    @data.organizations = ""

    if @data.address.length < 1 || @data.address == "What is your affiliation?"
      @showError @$("input[name=affiliation]"), @$(".error.address"), "Please enter a valid affiliation"
      return

    @verified()

  verified: ->
    new_api = "/api" + @communityExterior.links.registration[(if (@data.isFacebook) then "facebook" else "new")]
    $.post new_api, @data, _.bind((response) ->
      if response.success is "true" or response.id
        CommonPlace.account = new Account(response)
        if @hasAvatarFile and not @data.isFacebook
          @avatarUploader.submit()
        else
          @complete()
      else
        unless _.isEmpty(response.facebook)
          window.location.pathname = @communityExterior.links.facebook_login
        else unless _.isEmpty(response.password)
          @$(".error").text response.password[0]
          @$(".error").show()
    , this)

  referrers: ->
    @communityExterior.referral_sources
)
