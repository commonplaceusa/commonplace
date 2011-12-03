
var CommunityResources = CommonPlace.View.extend({
  template: "main_page.community-resources",
  id: "community-resources",

  initialize: function(options) {
    var self = this;
    var community = this.options.community;

    community.posts.bind("add", function() { self.switchTab("posts"); });
    community.announcements.bind("add", function() { self.switchTab("announcements"); });
    community.events.bind("add", function() { self.switchTab("events"); });
    community.groupPosts.bind("add", function() { self.switchTab("groupPosts"); });
  },

  afterRender: function() {
    this.switchTab("landing");
  },

  switchTab: function(tab) {
    this.$(".tab-button").removeClass("current");
    this.$("." + tab).addClass("current");

    var view = this.tabs[tab](this);
    view.render();
    this.$(".resources").replaceWith(view.el);
  },

  tabs: {
    landing: function(self) {
      return new LandingResources({
        account: self.options.account,
        community: self.options.community
      });
    },
    
    posts: function(self) {
      var postsCollection;
      if (self.options.community.get('locale') == "college") {
        postsCollection = self.options.account.neighborhoodsPosts();
      } else {
        postsCollection = self.options.community.posts;
      }

      return new self.PaginatingResourceWire({
        template: "main_page.post-resources",
        emptyMessage: "No posts here yet",
        collection: postsCollection,
        modelToView: function(model) {
          return new PostWireItem({ model: model, account: self.options.account });
        }
      });
    },

    events: function(self) {
      return new self.PaginatingResourceWire({
        template: "main_page.event-resources",
        emptyMessage: "No events here yet",
        collection: self.options.community.events,
        modelToView: function(model) {
          return new EventWireItem({ model: model, account: self.options.account });
        }
      });
    },
    
    announcements: function(self) {
      return new self.PaginatingResourceWire({
        template: "main_page.announcement-resources",
        emptyMessage: "No announcements here yet",
        collection: self.options.community.announcements,
        modelToView: function(model) {
          return new AnnouncementWireItem({ model: model, account: self.options.account });
        }
      });
    },

    groupPosts: function(self) {
      return new self.PaginatingResourceWire({
        template: "main_page.group-post-resources",
        emptyMessage: "No posts here yet",
        collection: self.options.community.groupPosts,
        modelToView: function(model) {
          return new GroupPostWireItem({ model: model, account: self.options.account });
        }
      });
    },

    users: function(self) {
      return new self.PaginatingResourceWire({
        template: "main_page.directory-resources",
        emptyMessage: "No posts here yet",
        collection: self.options.community.users,
        active: 'users',
        modelToView: function(model) {
          return new UserWireItem({ model: model, account: self.options.account });
        }
      });
    },

    groups: function(self) {
      return new self.ResourceWire({
        template: "main_page.directory-resources",
        emptyMessage: "No posts here yet",
        collection: self.options.community.groups,
        active: 'groups',
        modelToView: function(model) {
          return new GroupWireItem({ model: model, account: self.options.account });
        }
      });
    },

    feeds: function(self) {
      return new self.ResourceWire({
        template: "main_page.directory-resources",
        emptyMessage: "No posts here yet",
        collection: self.options.community.feeds,
        active: 'feeds',
        modelToView: function(model) {
          return new FeedWireItem({ model: model, account: self.options.account });
        }
      });
    }
  },

  PaginatingResourceWire: PaginatingWire.extend({
    className: "resources",
    _defaultPerPage: 15
  }),

  ResourceWire: Wire.extend(
    {
      className: "resources",
      usersLinkClass: function() {
        return this.options.active == 'users' ? 'current' : '';
      },
      feedsLinkClass: function() {
        return this.options.active == 'feeds' ? 'current' : '';
      },
      groupsLinkClass: function() {
        return this.options.active == 'groups' ? 'current' : '';
      }
    }
  ),

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
        var item = new ItemView({model: model, account: self.options.account});

        self.$(".tab-button").removeClass("current");

        item.render();

        self.$(".resources").html($("<div/>", { 
          "class": "wire",
          html: $("<ul/>", {
            "class": "wire-list",
            html: item.el
          })
        }));
      }
    });
  }
});
