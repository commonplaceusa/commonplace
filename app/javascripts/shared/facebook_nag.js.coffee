CommonPlace.shared.FacebookNag = CommonPlace.View.extend(
  template: "shared.facebook-nag"
  events:
    "click a.cancel": (e) ->
      e.preventDefault()
      CommonPlace.account.set_metadata "completed_facebook_nag", true
      @$el.hide()
      CommonPlace.layout.reset()

    "click a.connect": (e) ->
      e.preventDefault()
      facebook_connect_post_registration()
      @$el.hide()
      CommonPlace.layout.reset()
)
