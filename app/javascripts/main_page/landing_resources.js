var LandingResources = CommonPlace.View.extend({
  template: "main_page/landing-resources",
  className: "landing-resources",

  afterRender: function() {
    //fixme: invoke should be a function on the enumerable object
    _(this.wires()).invoke("render");
    setTimeout(function() {
      if (Features.isActive("fixedLayout")) {
        // by removing zindex of the underneath subnav, we may be able to avoid this
        $('form.search').detach().appendTo($('.landing-resources'));
      }
    }, 50);
  },

  wires: function() {
    var collection;
    if (CommonPlace.community.get('locale') == "college") {
      collection = CommonPlace.account.neighborhoodsPosts();
    } else {
      collection = CommonPlace.community.posts;
    }
    if (!this._wires) {
      this._wires = [
        (new WireHeader({
          template: 'main_page/post-resources',
          search: true,
          el: this.$(".posts.wireHeader")
        })),
        (new PreviewWire({
          collection: collection,
          el: this.$(".posts.wire"),
          emptyMessage: "No posts here yet.",
          isRecent: true,
          modelToView: function(model) {
            return new PostWireItem({ model: model });
          }
        })),

        (new WireHeader({
          template: 'main_page/event-resources',
          el: this.$(".events.wireHeader")
        })),
        (new PreviewWire({
          collection: CommonPlace.community.events,
          el: this.$(".events.wire"),
          emptyMessage: "There are no upcoming events yet. Add some.",
          isRecent: true,
          modelToView: function(model) {
            return new EventWireItem({ model: model });
          }
        })),

        (new WireHeader({
          template: 'main_page/announcement-resources',
          el: this.$(".announcements.wireHeader")
        })),
        (new PreviewWire({
          collection: CommonPlace.community.announcements,
          el: this.$(".announcements.wire"),
          emptyMessage: "No announcements here yet.",
          isRecent: true,
          modelToView: function(model) {
            return new AnnouncementWireItem({ model: model });
          }
        })),

        (new WireHeader({
          template: 'main_page/group-post-resources',
          el: this.$(".groupPosts.wireHeader")
        })),
        (new PreviewWire({
          collection: CommonPlace.community.groupPosts,
          el: this.$(".groupPosts.wire"),
          emptyMessage: "No posts here yet.",
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
