#= require ./main_page/forms/base
#= require_tree ./main_page
CommonPlace.CommunityPage = CommonPlace.View.extend(
  template: "main_page.main-page"
  id: "main"
  track: true
  page_name: "community"
  initialize: (options) ->
    self = this
    @account = CommonPlace.account
    @community = CommonPlace.community
    @lists = new CommonPlace.main.CommunityResources(
      account: @account
      community: @community
    )
    @sidebar = new CommonPlace.shared.Sidebar(
      nav: new CommonPlace.shared.YourTown()
      directory: new CommonPlace.shared.Directory()
    )
      
    @views = [@sidebar, @lists]

  afterRender: ->
    self = this
    _(@views).each (view) ->
      view.render()
      self.$("#" + view.id).replaceWith view.el

    CommonPlace.layout.reset()

  bind: ->
    $("body").addClass "community"
    CommonPlace.layout.bind()

  unbind: ->
    $("body").removeClass "community"
    CommonPlace.layout.unbind()
)
$ ->
  if Features.isActive("2012Release")
    $("body").addClass "fixedLayout"
    CommonPlace.layout = new FixedLayout()
  else
    CommonPlace.layout = new StaticLayout()

