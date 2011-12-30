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
      if (Features.isActive("2012Release")) {
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
          isRecent: true
         })),
        
        (new PreviewWire({
          template: 'main_page.event-resources',
          collection: this.community.events,
          account: this.account,
          el: this.$(".events.wire"),
          fullWireLink: "#/events",
          emptyMessage: "There are no upcoming events yet. Add some.",
          isRecent: true
        })),
        
        (new PreviewWire({
          template: 'main_page.announcement-resources',
          collection: this.community.announcements,
          account: this.account,
          el: this.$(".announcements.wire"),
          emptyMessage: "No announcements here yet.",
          fullWireLink: "#/announcements",
          isRecent: true
        })),
        
        (new PreviewWire({
          template: 'main_page.group-post-resources',
          collection: this.community.groupPosts,
          account: this.account,
          el: this.$(".groupPosts.wire"),
          emptyMessage: "No posts here yet.",
          fullWireLink: "#/group_posts",
          isRecent: true
        }))
      ];
    }
    return this._wires;
  },
  
  stickHeader: function() {
    var landing_top = $(this.el).offset().top + $(window).scrollTop();

    var wires_below_header = _.filter(this._wires, function(wire) {
      var wire_bottom = wire.el.offset().top + wire.el.height();
      return wire_bottom >= landing_top;
    });
    
    var top_wire = wires_below_header.shift();
    
    if (top_wire != this.headerWire) {
      this.unstickHeader();
      top_wire.header.detach().appendTo($("#community-resources .sticky-header"));
      this.headerWire = top_wire;
    }
  },
  
  unstickHeader: function() {
    if (this.headerWire) {
      this.headerWire.header.detach().prependTo(this.headerWire.el);
      $("#community-resources .sticky-header").empty();
    }
  }

});
