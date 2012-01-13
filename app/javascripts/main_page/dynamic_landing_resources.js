var DynamicLandingResources = CommonPlace.View.extend({
  template: "main_page.dynamic-landing-resources",
  className: "resources",
  
  afterRender: function() {
    this._sortCountdown = 0;
    
    this.raw = new CommunityWire({ uri: CommonPlace.community.link("landing_wires")});
    
    var self = this;
    this.raw.fetch({}, function() {
      _.each(self.wires(), function(wire) {
        wire.render();
      });
    });
  },
  
  wires: function(raw) {
    this._events = new LandingPreview({
      template: "main_page.event-resources",
      collection: this.raw.events,
      el: this.$(".events.wire"),
      fullWireLink: "#/events",
      emptyMessage: "There are no upcoming events yet. Add some."
    });
    this._events.render();
    
    var self = this;
    if (!this._wires) {
      this._wires = [
        (new LandingPreview({
          template: "main_page.post-resources",
          collection: this.raw.neighborhood,
          el: this.$(".neighborhoodPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No posts here yet.",
          callback: function() { self.displayPreviews(); }
        })),
        
        (new LandingPreview({
          template: "main_page.post-offer-resources",
          collection: this.raw.offers,
          el: this.$(".offerPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No offers here yet.",
          callback: function() { self.displayPreviews(); }
        })),
        
        (new LandingPreview({
          template: "main_page.post-help-resources",
          collection: this.raw.help,
          el: this.$(".helpPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No help requests here yet.",
          callback: function() { self.displayPreviews(); }
        })),
        
        (new LandingPreview({
          template: "main_page.post-publicity-resources",
          collection: this.raw.publicity,
          el: this.$(".publicityPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No posts here yet.",
          callback: function() { self.displayPreviews(); }
        })),
        
        (new LandingPreview({
          template: "main_page.post-other-resources",
          collection: this.raw.other,
          el: this.$(".otherPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No offers here yet.",
          callback: function() { self.displayPreviews(); }
        })),
        
        (new LandingPreview({
          template: "main_page.announcement-resources",
          collection: this.raw.announcements,
          el: this.$(".announcements.wire"),
          fullWireLink: "#/announcements",
          emptyMessage: "No announcements here yet.",
          callback: function() { self.displayPreviews(); }
        })),
        
        (new LandingPreview({
          template: "main_page.group-post-resources",
          collection: this.raw.groupPosts,
          el: this.$(".groupPosts.wire"),
          fullWireLink: "#/group_posts",
          emptyMessage: "No offers here yet.",
          callback: function() { self.displayPreviews(); }
        }))
      ];
    }
    return this._wires;
  },
  
  displayPreviews: function() {
    this._sortCountdown++;
    var self = this;
    
    if (this._sortCountdown == this._wires.length) {
      var duplicates = [];
      
      var sorted = _.filter(this._wires, function(wire) {
        duplicates.push(wire.collection.models);
        return wire.collection.length > 0;
      });
      
      if (sorted.length > 0) {
        sorted = _.sortBy(sorted, function(wire) {
          return parseDate(wire.collection.first().get("published_at"));
        });
        
        sorted.reverse(); // underscore is sorting it in reverse
        
        var first = sorted.shift();
        first.el.detach();
        this.$(".populated").prepend(first.el);
        
        
        _.each(sorted, function(wire) {
          wire.el.detach();
          self.$(".populated").append(wire.el);
        });
        
        this._chrono = new Wire({
          template: "main_page.chrono-resources",
          collection: CommonPlace.community.postlikes,
          el: this.$(".chrono.wire"),
          emptyMessage: "No posts here yet.",
          perPage: 22
        });
        
        duplicates.push(this._events.collection.models);
        this._chrono.collection.setDupes(_.flatten(duplicates));
        this._chrono.render();
      }
      
      this.stickHeader(true);
    }
  },
  
  stickHeader: function(ready) {
    if (ready || this._ready) {
      this._ready = true;
      var landing_top = $(this.el).offset().top + $(window).scrollTop();
      var landing_bottom = landing_top + this.$(".sticky-header").height();
      var wires_below_header = _.flatten([this._wires, this._events, this._chrono]);
      
      wires_below_header = _.filter(wires_below_header, function(wire) {
        var wire_bottom = wire.el.offset().top + wire.el.height();
        return wire_bottom >= landing_bottom;
      });
      
      var top_wire = _.sortBy(wires_below_header, function(wire) {
        return wire.el.offset().top;
      }).shift();
      
      if (top_wire != this.headerWire) {
        this.unstickHeader();
        var sticky = top_wire.header.clone(true);
        sticky.appendTo($("#community-resources .sticky-header"));
        this.headerWire = top_wire;
      }
    }
  },
  
  unstickHeader: function() {
    if (this._ready && this.headerWire) {
      $("#community-resources .sticky-header").empty();
    }
  },
  
  search: function() {},
  
  cancelSearch: function() {}
});

var LandingPreview = PreviewWire.extend({
  template: "wires.preview-wire",
  _defaultPerPage: 3,
  aroundRender: function(render) { render(); },
  fullWireLink: function() { return this.options.fullWireLink; },
  showMore: function() {},
  areMore: function() { return false; },
  isRecent: function() { return true; }
});
