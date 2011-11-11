var LandingResources = CommonPlace.View.extend({ 
  template: "main_page.landing-resources",
  className: "resources",

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
  },

  afterRender: function() {
    _(this.wires()).invoke("render");
    setTimeout(function() {
      if (Features.isActive("fixedLayout")) {
        // by removing zindex of the underneath subnav, we may be able to avoid this
        $('form.search').detach().appendTo($('.landing-resources'));
      }
    }, 50);
  },

  wires: function() {
    var self = this;
    var postsCollection;
    if (self.options.community.get('locale') == "college") {
      postsCollection = self.options.account.neighborhoodsPosts();
    } else {
      postsCollection = self.options.community.posts;
    }
    if (!this._wires) {
      this._wires = [
        (new PreviewWire({
          template: 'main_page.post-resources',
          collection: postsCollection,
          account: this.account,
          el: this.$(".posts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No posts here yet.",
          isRecent: true,
          modelToView: function(model) {
            return new PostWireItem({ model: model, account: self.options.account });
          }
         })),
        
        (new PreviewWire({
          template: 'main_page.event-resources',
          collection: this.community.events,
          account: this.account,
          el: this.$(".events.wire"),
          fullWireLink: "#/events",
          emptyMessage: "There are no upcoming events yet. Add some.",
          isRecent: true,
          modelToView: function(model) {
            return new EventWireItem({ model: model, account: self.options.account });
          }
        })),
        
        (new PreviewWire({
          template: 'main_page.announcement-resources',
          collection: this.community.announcements,
          account: this.account,
          el: this.$(".announcements.wire"),
          emptyMessage: "No announcements here yet.",
          fullWireLink: "#/announcements",
          isRecent: true,
          modelToView: function(model) {
            return new AnnouncementWireItem({ model: model, account: self.options.account });
          }
        })),
        
        (new PreviewWire({
          template: 'main_page.group-post-resources',
          collection: this.community.groupPosts,
          account: this.account,
          el: this.$(".groupPosts.wire"),
          emptyMessage: "No posts here yet.",
          fullWireLink: "#/group_posts",
          isRecent: true,
          modelToView: function(model) {
            return new GroupPostWireItem({ model: model, account: self.options.account });
          }
        }))
      ];
    }
    return this._wires;
  }
  

});
