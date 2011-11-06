
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

  switchTab: function(tab) {
    var self = this,
      $tabContent = self.$(".resources"),
      views = this.tabs[tab](); // todo simplify

    this.$(".tab-button").removeClass("current");
    this.$("." + tab).addClass("current");

    $tabContent.html('');
    _.each(views, function(view){
      view.render();
      $tabContent.append(view.el);
    });

    if (window['mpq'] !== undefined){ // todo: move this in to helper method under CommonPlace
      mpq.track('Wire:' + tab, {'community': CommonPlace.community.get('slug') });
    }
  },

  tabs: {
    landing: function() {
      return [( new LandingResources() )];
    },

    posts: function() {
      var collection; //TODO: DRY this (against landing_resources)
      if (CommonPlace.community.get('locale') == "college") {
        collection = CommonPlace.account.neighborhoodsPosts();
      } else {
        collection = CommonPlace.community.posts;
      }

      return [
        (new WireHeader({
          template: 'main_page/post-resources' //fixme: DRY this and just past in an initialization arg
        })),
        (new PaginatingResourceWire({
          collection: collection,
          className: "posts wire",
          modelToView: function(model) {  //fixme: passage of model not dry
            return new PostWireItem({ model: model });
          }
        }))
      ];

    },

    events: function() {
      return [
        (new WireHeader({
          template: 'main_page/event-resources'
        })),
        (new PaginatingResourceWire({
          emptyMessage: "No events here yet", //todo: dry this crap..
          collection: CommonPlace.community.events,
          className: "events wire",
          modelToView: function(model) {
            return new EventWireItem({ model: model });
          }
        }))
      ];
    },

    announcements: function() {
      return [
        (new WireHeader({
          template: 'main_page/announcement-resources'
        })),
        (new PaginatingResourceWire({
          emptyMessage: "No announcements here yet", //todo: dry this crap..
          collection: CommonPlace.community.announcements,
          className: "announcements wire",
          modelToView: function(model) {
            return new AnnouncementWireItem({ model: model });
          }
        }))
      ];
    },

    groupPosts: function() {
      return [
        (new WireHeader({
          template: "main_page/group-post-resources"
        })),
        (new PaginatingResourceWire({
          emptyMessage: "No posts here yet",
          collection: CommonPlace.community.groupPosts,
          className: "groupPosts wire",
          modelToView: function(model) {
            return new GroupPostWireItem({ model: model });
          }
        }))
      ];
    },

    users: function() {
      return [
        (new WireHeader({
          template: "main_page/directory-resources"
        })),
        (new ResourceWire({
          emptyMessage: "No posts here yet",
          collection: CommonPlace.community.users,
          className: "users wire",
          active: 'users',
          modelToView: function(model) {
            return new UserWireItem({ model: model });
          }
        }))
      ];
    },

    groups: function() {
      return [
        (new WireHeader({
          template: "main_page/directory-resources"
        })),
        (new ResourceWire({
          emptyMessage: "No posts here yet",
          collection: CommonPlace.community.groups,
          className: "users wire",
          active: 'groups',
          modelToView: function(model) {
            return new GroupWireItem({ model: model });
          }
        }))
      ];
    },

    feeds: function() {
      return [
        (new WireHeader({
          template: "main_page/directory-resources"
        })),
        (new ResourceWire({
          emptyMessage: "No posts here yet",
          collection: CommonPlace.community.feeds,
          className: "users wire",
          active: 'feeds',
          modelToView: function(model) {
            return new FeedWireItem({ model: model });
          }
        }))
      ];
    }
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
        var item = new ItemView({model: model});

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
