CommonPlace.registration.ApplicationOrNominationSubmittedView = CommonPlace.View.extend(
  template: "registration.application_or_nomination_submitted"
  events:
    "click .register-button": "register"
    "click .facebook": "share_on_facebook"

  applying: ->
    @options.applying_or_nominating is "applying"

  nominating: ->
    @options.applying_or_nominating is "nominating"

  nominee_name: ->
    @options.nominee_name

  nominee_first_name: ->
    unless @options.nominee_name.indexOf(" ") is -1
      @options.nominee_name.split(" ")[0]
    else
      @options.nominee_name

  register: ->
    community_slug = CommonPlace.community.get("slug")
    about_page_url = "/" + community_slug + "/about"
    window.location = about_page_url

  share_on_facebook: (e) ->
    e and e.preventDefault()
    FB.ui
      method: "feed"
      name: "OurCommonPlace Civic Hero Nomination"
      link: "https://" + CommonPlace.community.get("slug") + ".ourcommonplace.com/nominate"
      description: "I just nominated my neighbor for a Civic Hero Award on the " + CommonPlace.community.get("name") + " CommonPlace!"
      display: "popup"
      redirect_uri: "https://www.ourcommonplace.com/close_dialog"
    , (response) ->
      FB.Dialog.remove FB.Dialog._active

)
