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
    if (!this._wires) { 
      this._wires = [
        (new PreviewWire({ 
          collection: this.community.posts,
          account: this.account,
           el: this.$(".posts.wire"),
           perPage: 3,
           fullLink: "#/posts",
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
          modelToView: function(model) {
            return new EventWireItem({ model: model, account: self.options.account });
          }
        })),
        
        (new PreviewWire({ 
          collection: this.community.announcements,
          account: this.account,
          el: this.$(".announcements.wire"),
          perPage: 3,
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
