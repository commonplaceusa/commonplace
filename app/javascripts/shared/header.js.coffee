CommonPlace.shared.HeaderView = CommonPlace.View.extend(
  template: "shared.new_header.header-view"
  id: "header"

  events:
    "click .post": "showPostbox"

  afterRender: ->
    nav = undefined
    if CommonPlace.account.isAuth()
      nav = new CommonPlace.shared.HeaderNav()
    else
      nav = new CommonPlace.shared.HeaderLogin()
    window.HeaderNavigation = nav
    nav.render()
    @$(".nav").replaceWith nav.el

  showPostbox: (e) ->
    if e
      e.preventDefault()
    @postbox = new CommonPlace.main.PostBox
      account: CommonPlace.account
      community: CommonPlace.community
    @postbox.render()

  root_url: ->
    if CommonPlace.account.isAuth()
      "/" + CommonPlace.account.get("community_slug")
    else
      "/" + CommonPlace.community.get("slug")  if CommonPlace.community

  hasCommunity: ->
    CommonPlace.community

  community_name: ->
    if CommonPlace.account.isAuth()
      CommonPlace.account.get "community_name"
    else
      CommonPlace.community.get "name"  if CommonPlace.community

  community_url: ->
    if CommonPlace.community
      @root_url()
    else
      "/info"

  isAuth: ->
    CommonPlace.account.isAuth()

)
