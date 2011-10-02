
var CommunityResources = CommonPlace.View.extend({
  template: "main_page/community-resources",
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
      return new self.PaginatingResourceWire({
        template: "main_page/post-resources",
        perPage: 15,
        emptyMessage: "No posts here yet",
        collection: self.options.community.posts,
        modelToView: function(model) {
          return new PostWireItem({ model: model, account: self.options.account });
        }
      });
    },

    events: function(self) {
      return new self.PaginatingResourceWire({
        template: "main_page/event-resources",
        perPage: 15,
        emptyMessage: "No events here yet",
        collection: self.options.community.events,
        modelToView: function(model) {
          return new EventWireItem({ model: model, account: self.options.account });
        }
      });
    },
    
    announcements: function(self) {
      return new self.PaginatingResourceWire({
        template: "main_page/announcement-resources",
        perPage: 15,
        emptyMessage: "No announcements here yet",
        collection: self.options.community.announcements,
        modelToView: function(model) {
          return new AnnouncementWireItem({ model: model, account: self.options.account });
        }
      });
    },

    groupPosts: function(self) {
      return new self.PaginatingResourceWire({
        template: "main_page/group-post-resources",
        perPage: 15,
        emptyMessage: "No posts here yet",
        collection: self.options.community.groupPosts,
        modelToView: function(model) {
          return new GroupPostWireItem({ model: model, account: self.options.account });
        }
      });
    },

    users: function(self) {
      return new self.ResourceWire({
        template: "main_page/user-resources",
        perPage: 15,
        emptyMessage: "No posts here yet",
        collection: self.options.community.users,
        modelToView: function(model) {
          return new UserWireItem({ model: model, account: self.options.account });
        }
      });
    },

    groups: function(self) {
      return new self.ResourceWire({
        template: "main_page/group-resources",
        perPage: 15,
        emptyMessage: "No posts here yet",
        collection: self.options.community.groups,
        modelToView: function(model) {
          return new GroupWireItem({ model: model, account: self.options.account });
        }
      });
    },

    feeds: function(self) {
      return new self.ResourceWire({
        template: "main_page/feed-resources",
        perPage: 15,
        emptyMessage: "No posts here yet",
        collection: self.options.community.feeds,
        modelToView: function(model) {
          return new FeedWireItem({ model: model, account: self.options.account });
        }
      });
    }
  },

  PaginatingResourceWire: PaginatingWire.extend({ className: "resources" }),

  ResourceWire: Wire.extend({ className: "resources" }),

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
