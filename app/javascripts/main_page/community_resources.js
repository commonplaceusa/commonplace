
var CommunityResources = CommonPlace.View.extend({
  template: "main_page.community-resources",
  id: "community-resources",

  initialize: function(options) {
    var self = this;
    var community = this.options.community;
  },
  
  afterRender: function() {
    var self = this;
    if (Features.isActive("fixedLayout")) {
      $(window).scroll(function() { self.view.stickHeader(); });
    }
  },

  switchTab: function(tab) {
    this.$(".tab-button").removeClass("current");
    this.$("." + tab).addClass("current");
    
    if (Features.isActive("fixedLayout") && this.view) {
      this.view.unstickHeader();
    }

    this.view = this.tabs[tab](this);
    this.view.render();
    this.$(".resources").replaceWith(this.view.el);
    
    if (Features.isActive("fixedLayout")) {
      this.view.stickHeader();
    }
  },

  tabs: {
    landing: function(self) {
      if (Features.isActive("dynamicLanding")) {
        return new DynamicLandingResources({});
      } else {
        return new LandingResources({
          account: self.options.account,
          community: self.options.community
        });
      }
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
        collection: postsCollection
      });
    },

    events: function(self) {
      return new self.PaginatingResourceWire({
        template: "main_page.event-resources",
        emptyMessage: "No events here yet",
        collection: self.options.community.events
      });
    },
    
    announcements: function(self) {
      return new self.PaginatingResourceWire({
        template: "main_page.announcement-resources",
        emptyMessage: "No announcements here yet",
        collection: self.options.community.announcements
      });
    },

    groupPosts: function(self) {
      return new self.PaginatingResourceWire({
        template: "main_page.group-post-resources",
        emptyMessage: "No posts here yet",
        collection: self.options.community.groupPosts
      });
    },

    users: function(self) {
      return new self.PaginatingResourceWire({
        template: "main_page.directory-resources",
        emptyMessage: "No posts here yet",
        collection: self.options.community.users,
        active: 'users'
      });
    },

    groups: function(self) {
      return new self.PaginatingResourceWire({
        template: "main_page.directory-resources",
        emptyMessage: "No posts here yet",
        collection: self.options.community.groups,
        active: 'groups'
      });
    },

    feeds: function(self) {
      return new self.PaginatingResourceWire({
        template: "main_page.directory-resources",
        emptyMessage: "No posts here yet",
        collection: self.options.community.feeds,
        active: 'feeds'
      });
    }
  },

  PaginatingResourceWire: Wire.extend({
    className: "resources",
    _defaultPerPage: 15,
    
    stickHeader: function() {},
    
    unstickHeader: function() {}
  }),

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
