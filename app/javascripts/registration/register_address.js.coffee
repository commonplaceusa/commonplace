CommonPlace.registration.AddressView = CommonPlace.registration.RegistrationModalPage.extend(
  template: "registration.address"
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click .next-button": "submit"
    "click .confirm": "verified"

  afterRender: ->
    @hasAvatarFile = false
    @initReferralQuestions()
    $("#current-registration-page").html @el
    @$("input[placeholder]").placeholder()
    url = "/api/communities/" + @communityExterior.id + "/address_completions"
    @$("input[name=address]").autocomplete
      source: url
      minLength: 1
      autoFocus: true

  user_name: ->
    (if (@data.full_name) then @data.full_name.split(" ")[0] else "")

  submit: (e) ->
    e.preventDefault()  if e
    @$(".error").hide()
    @data.address = @$("input[name=address]").val()
    @data.referral_source = @$("select[name=referral_source]").val()
    @data.referral_metadata = @$("input[name=referral_metadata]").val()
    @data.organizations = ""

    if @data.address.length < 1
      @showError @$("input[name=address]"), @$(".error.address"), "Please enter a valid address"
      return

    if @data.referral_source is "placeholder"
      @showError @$("select[name=referral_source]"), @$(".error.referral_source"), "Please tell us how you heard about OurCommonPlace"
      return

    if @$("#address_verification").is(":hidden")
      @data.term = @data.address

      url = '/api/communities/' + @communityExterior.id + '/address_approximate'
      $.get url, @data, _.bind((response) ->
        div = @$("#address_verification")
        radio = @$("input.address_verify_radio")
        span = @$("span.address_verify_radio")
        addr = @$("#suggested_address")
        weight = parseFloat(response[0])

        if weight != -1
          if response[1].length < 1 || weight < 0.84
            @showError @$("input[name=address]"), @$(".error.address"), "Please enter a valid address"
            @$("#bypass").show()
            return
          else if weight < 0.94
            @data.suggest = response[1]

            addr.empty()
            addr.text(response[1])

            div.show()
            radio.show()
            span.show()
            addr.show()
            return
          else
            @data.address = response[1]
            @verified()
        else
          @verified()
      , this)
    else
      if @$("#suggested").is(':checked')
        @data.address = @data.suggest

      @verified()

  verified: ->
    new_api = "/api" + @communityExterior.links.registration[(if (@data.isFacebook) then "facebook" else "new")]
    $.post new_api, @data, _.bind((response) ->
      if response.success is "true" or response.id
        CommonPlace.account = new Account(response)
        if @hasAvatarFile and not @data.isFacebook
          @avatarUploader.submit()
        else
          delete @data.term
          delete @data.suggest
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

  initReferralQuestions: ->
    @$("#referral_metadata").hide()
    @$("select.dk").dropkick(
      change: _.bind((value, label)->
        question =
          "On Facebook": "From who?"
          "Postcard at a business": "What business?"
          "Through a neighbor": "From who?"
          "In an email": "From who?"
          "In the news": "What news source?"
          "From another website": "Which one?"
          "Other": "Where?"
        meta = question[value]
        if meta
          @$("input[name=referral_metadata]").attr("placeholder", meta)
          @$("#referral_metadata").show()
        else
          @$("#referral_metadata").hide()
      , this)
    )
)
