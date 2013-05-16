CommonPlace.registration.AffiliationView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.affiliation"
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click .next-button": "submit"

  afterRender: ->
    @$("select.dk").dropkick()
    @$("input[placeholder]").placeholder()
    @fadeIn @el

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
    new_api = "/api" + CommonPlace.community.get("links").registration[(if (@data.isFacebook) then "facebook" else "new")]
    $.post new_api, @data, _.bind((response) ->
      if response.success is "true" or response.id
        CommonPlace.account = new Account(response)
        window.location = window.location.protocol + "//" + window.location.host + "/" + CommonPlace.community.get("slug") #performing the redirect this way ensures it works with IE and the hash routing
      else
        unless _.isEmpty(response.facebook)
          window.location.pathname = CommonPlace.community.get("links").facebook_login
        else unless _.isEmpty(response.password)
          @$(".error").text response.password[0]
          @$(".error").show()
    , this)
)
