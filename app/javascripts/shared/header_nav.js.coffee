CommonPlace.shared.HeaderNav = CommonPlace.View.extend(
  template: "shared.new_header.header-nav"
  className: "nav"
  unreadMessageCount: 0
  afterRender: ->
    @updateUnreadMessages()
    @updateUnreadMessagesBadge()
    self = this
    CommonPlace.account.on "sync", ->
      self.updateUnreadMessages()
      self.updateUnreadMessagesBadge()


  slug: ->
    if CommonPlace.account.isAuth()
      CommonPlace.account.get "community_slug"
    else
      CommonPlace.community.get "slug"

  invite_url: ->
    "/" + @slug() + "/invite"

  inbox_url: ->
    "/" + @slug() + "/inbox"

  avatar_url: ->
    CommonPlace.account.get "avatar_url"

  account_url: ->
    "/" + @slug() + "/account"

  faq_url: ->
    "/" + @slug() + "/faq"

  short_name: ->
    CommonPlace.account.get "short_name"

  neighbor_discount_url: ->

  privacy_url: ->
    "/" + @slug() + "/privacy"

  feeds: ->
    CommonPlace.account.get "feeds"

  activityIsEnabled: ->
    @isActive "CPCreditsHeaderView"

  unreadMessages: ->
    @unreadMessageCount

  updateUnreadMessages: ->
    @unreadMessageCount = CommonPlace.account.get("unread")

  hasUnreadMessages: ->
    @unreadMessages() isnt 0

  clearUnreadMessages: ->
    @unreadMessageCount = 0
    @updateUnreadMessagesBadge()

  updateUnreadMessagesBadge: ->
    if @hasUnreadMessages()
      @$(".inbox .file").badger "" + @unreadMessages()
    else
      @$(".inbox .file").badger ""
)
