var LandingResources = CommonPlace.View.extend({
  template: "main_page/landing-resources",
  className: "landing-resources",

  afterRender: function() {
    //fixme: invoke should be a function on the enumerable object
    _(this.wires()).invoke("render");
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
          link: '/#posts',
          text: this.t('posts'),
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
          link: '/#events',
          text: this.t('events'),
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
          link: '/#announcements',
          text: this.t('announcements'),
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
          link: '/#groupPosts',
          text: this.t('group-posts'),
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
