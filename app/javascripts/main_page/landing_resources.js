var LandingResources = CommonPlace.View.extend({ 
  template: "main_page.landing-resources",
  className: "resources",

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
    if (CommonPlace.community.get('locale') == "college") {
      postsCollection = CommonPlace.account.neighborhoodsPosts();
    } else {
      postsCollection = CommonPlace.community.posts;
    }
    if (!this._wires) {
      this._wires = [
        (new PreviewWire({
          template: 'main_page.post-resources',
          collection: postsCollection,
          el: this.$(".posts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No posts here yet.",
          isRecent: true,
          modelToView: function(model) {
            return new PostWireItem({ model: model });
          }
         })),
        
        (new PreviewWire({
          template: 'main_page.event-resources',
          collection: CommonPlace.community.events,
          el: this.$(".events.wire"),
          fullWireLink: "#/events",
          emptyMessage: "There are no upcoming events yet. Add some.",
          isRecent: true,
          modelToView: function(model) {
            return new EventWireItem({ model: model });
          }
        })),
        
        (new PreviewWire({
          template: 'main_page.announcement-resources',
          collection: CommonPlace.community.announcements,
          el: this.$(".announcements.wire"),
          emptyMessage: "No announcements here yet.",
          fullWireLink: "#/announcements",
          isRecent: true,
          modelToView: function(model) {
            return new AnnouncementWireItem({ model: model });
          }
        })),
        
        (new PreviewWire({
          template: 'main_page.group-post-resources',
          collection: CommonPlace.community.groupPosts,
          el: this.$(".groupPosts.wire"),
          emptyMessage: "No posts here yet.",
          fullWireLink: "#/group_posts",
          isRecent: true,
          modelToView: function(model) {
            return new GroupPostWireItem({ model: model });
          }
        }))
      ];
    }
    return this._wires;
  }
  

});
