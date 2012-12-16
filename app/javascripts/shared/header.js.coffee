CommonPlace.shared.HeaderView = CommonPlace.View.extend(
  template: "shared.new_header.header-view"
  id: "header"

  beforeRender: ->
    if @community_slug() == 'HarvardNeighbors'
      @template = 'shared.new_header.harvard-header-view'

  afterRender: ->
    nav = undefined
    if CommonPlace.account.isAuth()
      nav = new CommonPlace.shared.HeaderNav()
    else
      nav = new CommonPlace.shared.HeaderLogin()
    window.HeaderNavigation = nav
    nav.render()
    @$(".nav").replaceWith nav.el

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

  notAuth: ->
    not CommonPlace.account.isAuth()
)
