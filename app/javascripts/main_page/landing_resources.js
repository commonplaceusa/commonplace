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
    this._wires || (this._wires = [
      new PostWireView({ collection: this.community.posts,
                         account: this.account,
                         el: this.$(".posts.wire"),
                         perPage: 3
                       }),

      new EventWireView({ collection: this.community.events,
                          account: this.account,
                          el: this.$(".events.wire"),
                          perPage: 3
                        }),

      new AnnouncementWireView({ collection: this.community.announcements,
                                 account: this.account,
                                 el: this.$(".announcements.wire"),
                                 perPage: 3
                               }),

      new GroupPostWireView({ collection: this.community.groupPosts,
                              account: this.account,
                              el: this.$(".groupPosts.wire"),
                              perPage: 3
                            })
    ]);
    return this._wires;
  }
  

});
