CommonPlace.shared.HeaderView = CommonPlace.View.extend(
  template: "shared.new_header.header-view"
  id: "header"

  events:
    "click .post": "showPostbox"

  afterRender: ->
    center = undefined
    right = undefined
    if CommonPlace.account.isAuth()
      if CommonPlace.account.isGuest()
        center = new CommonPlace.shared.HeaderSearch()
        right = new CommonPlace.shared.HeaderLogin()
        @$(".header_center").addClass("header_guest") #for changing the size of the search bar when not logged in
      else
        center = new CommonPlace.shared.HeaderSearch()
        right = new CommonPlace.shared.HeaderNav()
    else
      center = new CommonPlace.shared.HeaderWrongTown()
      right = new CommonPlace.shared.HeaderLogin()
    window.HeaderNavigation = right
    center.render()
    right.render()
    @$(".header_center").html center.el
    @$(".header_right").html right.el

  showPostbox: (e) ->
    e.preventDefault() if e
    return @showRegistration() if @isGuest()
    @postbox = new CommonPlace.main.PostBox
      account: CommonPlace.account
      community: CommonPlace.community
    @postbox.render()

  root_url: ->
    if CommonPlace.community
      "/" + CommonPlace.community.get("slug")
    else
      "/"

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
