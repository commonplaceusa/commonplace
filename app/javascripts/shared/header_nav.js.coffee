CommonPlace.shared.HeaderNav = CommonPlace.View.extend(
  template: "shared.new_header.header-nav"
  className: "nav"
  unreadMessageCount: 0

  events:
    "click .feed-link": "goToFeed"
    "click .create-feed-link": "showFeedCreationForm"

  initialize: ->
    @updateUnreadMessages()
    self = this
    CommonPlace.account.on "sync", ->
      self.updateUnreadMessages()
      self.updateUnreadMessagesBadge()
      self.render()

  goToFeed: (e) ->
    e.preventDefault() if e
    slug = CommonPlace.community.get("slug")
    id = e.currentTarget.id
    app.showFeedPage(slug, id)

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

  user_url: ->
    "/" + @slug() + "/show/users/" + CommonPlace.account.get("id")

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
      @$(".account").badger "" + @unreadMessages()
    else
      @$(".account").badger ""
)
