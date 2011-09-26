
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
  },

  showPost: function(post) {
    this.showSingleItem(post, GroupPostWireItem);
  },
  showAnnouncement: function(announcement) {
    this.showSingleItem(announcement, AnnouncementWireItem);
  },
  showEvent: function(event) {
    this.showSingleItem(event, EventWireItem);
  },
  showGroupPost: function(groupPost) {
    this.showSingleItem(groupPost, GroupPostWireItem);
  },

  showSingleItem: function(model, ItemView) {
    var self = this;
    model.fetch({
      success: function(model) {
        var item = new ItemView({model: model, account: self.account});

        self.$(".tab-button").removeClass("current");

        item.render();

        self.$(".resources").html($("<div/>", { 
          class: "wire",
          html: $("<ul/>", {
            class: "wire-list",
            html: item.el
          })
        }));
      }
    });
  }
});
