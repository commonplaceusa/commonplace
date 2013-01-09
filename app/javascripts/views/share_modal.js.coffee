CommonPlace.views.ShareModal = FormView.extend(
  template: "shared/share_modal"
  id: "share-modal"
  account: CommonPlace.account
  header: ""
  message: ""

  events:
    "click #facebookshare": "shareFacebook"
    "click #twittershare": "shareTwitter"
    "click #linkshare": "showLinkShare"
    "click .red-button": "exit"
    "click .close": "exit"
    "click #mailto-share": "markEmailShareChecked"

  avatar_url: ->
    url = @model.get("avatar_url")
    return "https://www.ourcommonplace.com/images/logo-pin.png"  if url is "https://s3.amazonaws.com/commonplace-avatars-production/missing.png"
    url

  share_url: ->
    CommonPlace.community.get("links")["base"] + "/show/" + @model.get("schema") + "/" + @model.get("id")

  share_message: ->
    "Check out this post on the #{@community_name()} OurCommonPlace:"

  set_header: (text) ->
    if text
      @header = text

  set_message: (text) ->
    if text
      @message = text

  item_name: ->
    @model.get "title"

  email_subject: ->
    "Check out this post on OurCommonPlace #{@community_name()}"

  email_body: ->
    "I thought you might like this post on OurCommonPlace, #{@community_name()}'s online town bulletin: #{@share_url()}"

  community_name: ->
    CommonPlace.community.get "name"

  shareFacebook: (e) ->
    e.preventDefault()
    $('.share-f').addClass("checked")
    $link = $(e.target)
    _kmq.push(['record', 'Share', {'Schema': @model.get("schema"), 'ID': @model.id, 'Medium': 'Facebook'}]) if _kmq?
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
    $('.share-t').addClass("checked")
    $link = $(e.target)
    _kmq.push(['record', 'Share', {'Schema': @model.get("schema"), 'ID': @model.id, 'Medium': 'Twitter'}]) if _kmq?
    url = encodeURIComponent($link.attr("data-url"))
    text = $link.attr("data-message")
    share_url = "https://twitter.com/intent/tweet?url=" + url + "&text=" + text + " " + url + "&count=horizontal"
    window.open share_url, "cp_share", 'height=500,width=500'

  markEmailShareChecked: (e) ->
    e.preventDefault if e
    $("#emailshare").addClass("checked")
    _kmq.push(['record', 'Share', {'Schema': @model.get("schema"), 'ID': @model.id, 'Medium': 'Email'}]) if _kmq?

  showEmailShare: (e) ->
    e.preventDefault()
    @$("#share-email").toggle()

  showLinkShare: (e) ->
    e.preventDefault()
    @$("#share_link").toggle()
    $("[name=share-link]").select()
    $("#linkshare").addClass("checked")
    _kmq.push(['record', 'Share', {'Schema': @model.get("schema"), 'ID': @model.id, 'Medium': 'Public Link'}]) if _kmq?

  submitEmail: (e) ->
    if e
      e.preventDefault()
    data =
      recipients: this.$("input[name=share-email]").val()

    if data.recipients isnt ""
      $("#emailshare").addClass("checked")

    $.ajax(
      type: "POST"
      url: "/api" + this.model.get("links").self + "/share_via_email"
      data: data
      success: (response) ->
        $("input[name=share-email]").val('')
        $("#emailshare").addClass("checked")
        _kmq.push(['record', 'Share', {'Medium': 'Email'}]) if _kmq?
      dataType: "JSON"
    )
)
