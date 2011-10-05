var LandingResources = CommonPlace.View.extend({ 
  template: "main_page/landing-resources",
  className: "resources",

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
  },

  afterRender: function() {
    _(this.wires()).invoke("render");
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
          collection: postsCollection,
          account: this.account,
          el: this.$(".posts.wire"),
          perPage: 3,
          fullLink: "#/posts",
          emptyMessage: "No posts here yet.",
          modelToView: function(model) {
            return new PostWireItem({ model: model, account: self.options.account });
          }
         })),
        
        (new PreviewWire({ 
          collection: this.community.events,
          account: this.account,
          el: this.$(".events.wire"),
          perPage: 3,
          fullLink: "#/events",
          emptyMessage: "There are no upcoming events yet. Add some.",
          modelToView: function(model) {
            return new EventWireItem({ model: model, account: self.options.account });
          }
        })),
        
        (new PreviewWire({ 
          collection: this.community.announcements,
          account: this.account,
          el: this.$(".announcements.wire"),
          perPage: 3,
          emptyMessage: "No announcements here yet.",
          fullLink: "#/announcements",
          modelToView: function(model) {
            return new AnnouncementWireItem({ model: model, account: self.options.account });
          }
        })),
        
        (new PreviewWire({ 
          collection: this.community.groupPosts,
          account: this.account,
          el: this.$(".groupPosts.wire"),
          perPage: 3,
          emptyMessage: "No posts here yet.",
          fullLink: "#/group_posts",
          modelToView: function(model) {
            return new GroupPostWireItem({ model: model, account: self.options.account });
          }
        }))
      ];
    }
    return this._wires;
  }
  

});
