
var CommunityResources = CommonPlace.View.extend({
  template: "main_page/community-resources",
  id: "community-resources",

  initialize: function(options) {
    var self = this;
    this.community = options.community;
    this.account = options.account;
    this.community.posts.bind("add", function() { self.switchTab("posts"); });
    this.community.announcements.bind("add", function() { self.switchTab("announcements"); });
    this.community.events.bind("add", function() { self.switchTab("events"); });
    this.community.groupPosts.bind("add", function() { self.switchTab("groupPosts"); });
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
    var ViewClass = { landing: LandingResources,
                      posts: PostResources,
                      events: EventResources,
                      announcements: AnnouncementResources,
                      groupPosts: GroupPostResources,
                      users: UserResources,
                      feeds: FeedResources,
                      groups: GroupResources 
                    }[tab];
    return new ViewClass({ community: this.community,
                           account: this.account });
  }
});
