
var CommunityResources = CommonPlace.View.extend({
  template: "main_page/community-resources",
  id: "community-resources",

  initialize: function(options) {
    this.community = options.community;
    this.account = options.account;
  },

  events: {
    "click .navigation .tab-button": "switchTabOnClick",
    "click .sub-navigation a": "switchTabOnClick"
  },

  afterRender: function() {
    this.switchTab("landing");
  },

  switchTab: function(tab) {
    this.$(".tab-button").removeClass("current");
    this.$("." + tab).addClass("current");

    var resources = this.resourcesView(tab);
    resources.render();
    this.$(".resources").replaceWith(resources.el);

  },

  resourcesView: function(tab) {
    var viewClass = { landing: LandingResources,
                      posts: PostResources,
                      events: EventResources,
                      announcements: AnnouncementResources,
                      groupPosts: GroupPostResources,
                      users: UserResources,
                      feeds: FeedResources,
                      groups: GroupResources 
                    }[tab];
    return new viewClass({ community: this.community,
                           account: this.account });
  },

  switchTabOnClick: function(e) {
    e.preventDefault();
    var tab = $(e.target).attr('href').split("#")[1];
    this.switchTab(tab);
  }

});
