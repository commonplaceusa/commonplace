CommonPlace.views.ShareView = CommonPlace.View.extend(
  className: "share"
  template: "shared/share"
  initialize: (options) ->
    @account = options.account

  afterRender: ->

  avatar_url: ->
    url = @model.get("avatar_url")
    return "https://www.ourcommonplace.com/images/logo-pin.png"  if url is "https://s3.amazonaws.com/commonplace-avatars-production/missing.png"
    url

  share_url: ->
    CommonPlace.community.get("links")["base"] + "/show/" + @model.get("schema") + "/" + @model.get("id")

  item_name: ->
    @model.get "title"

  events:
    "click .share-e": "showEmailShare"
    "click .share-f": "shareFacebook"
    "click .share-t": "shareTwitter"
    "click .email-button": "submitEmail"

  shareFacebook: (e) ->
    e.preventDefault()
    $link = $(e.target)
    FB.ui
      method: "feed"
      name: $link.attr("data-name")
      link: $link.attr("data-url")
      picture: $link.attr("data-picture")
      caption: $link.attr("data-caption")
      description: $link.attr("data-description")
      message: $link.attr("data-message")
    , $.noop

  shareTwitter: (e) ->
    e.preventDefault()
    $link = $(e.target)
    url = encodeURIComponent($link.attr("data-url"))
    text = $link.attr("data-message")
    share_url = "https://twitter.com/intent/tweet?url=" + url + "&text=" + text + "&count=horizontal"
    window.open share_url, "cp_share"

  showEmailShare: (e) ->
    e.preventDefault()
    @$("#share-email").show()

  submitEmail: (e) ->
    e.preventDefault()  if e
    $form = @$("form")
    $.ajax
      type: "POST"
      dataType: "json"
      url: "/api" + CommonPlace.community.link("shares")
      data: JSON.stringify(
        data_type: @model.get("schema")
        id: @model.get("id")
        email: $("[name=share-email]", $form).val()
      )
      success: ->
        $("[name=share-email", $form).val ""
        $form.hide()

      failure: ->
        $form.hide()
)
