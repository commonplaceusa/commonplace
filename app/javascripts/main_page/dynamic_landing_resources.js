var DynamicLandingResources = CommonPlace.View.extend({
  template: "main_page.dynamic-landing-resources",
  className: "resources",
  
  afterRender: function() {
    this._sortCountdown = 0;
    
    var self = this;
    
    this._events = new LandingPreview({
      template: 'main_page.event-resources',
      collection: CommonPlace.community.events,
      el: this.$(".events.wire"),
      fullWireLink: "#/events",
      emptyMessage: "There are no upcoming events yet. Add some."
    });
    
    this._events.render();
    
    _.each(this.wires(), function(wire) {
      wire.render();
    });
  },
  
  wires: function() {
    var self = this;
    if (!this._wires) {
      this._wires = [
        (new LandingPreview({
          template: 'main_page.post-resources',
          collection: CommonPlace.community.categories.neighborhood,
          el: this.$(".neighborhoodPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No posts here yet.",
          callback: function() { self.displayPreviews(); }
        })),
        
        (new LandingPreview({
          template: 'main_page.post-offer-resources',
          collection: CommonPlace.community.categories.offers,
          el: this.$(".offerPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No offers here yet.",
          callback: function() { self.displayPreviews(); }
        })),
        
        (new LandingPreview({
          template: 'main_page.post-help-resources',
          collection: CommonPlace.community.categories.help,
          el: this.$(".helpPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No help requests here yet.",
          callback: function() { self.displayPreviews(); }
        })),
        
        (new LandingPreview({
          template: 'main_page.post-publicity-resources',
          collection: CommonPlace.community.categories.publicity,
          el: this.$(".publicityPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No posts here yet.",
          callback: function() { self.displayPreviews(); }
        })),
        
        (new LandingPreview({
          template: 'main_page.post-other-resources',
          collection: CommonPlace.community.categories.other,
          el: this.$(".otherPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No posts here yet.",
          callback: function() { self.displayPreviews(); }
        })),
        
        (new LandingPreview({
          template: 'main_page.announcement-resources',
          collection: CommonPlace.community.announcements,
          el: this.$(".announcements.wire"),
          emptyMessage: "No announcements here yet.",
          fullWireLink: "#/announcements",
          callback: function() { self.displayPreviews(); }
        })),
        
        (new LandingPreview({
          template: 'main_page.group-post-resources',
          collection: CommonPlace.community.groupPosts,
          el: this.$(".groupPosts.wire"),
          emptyMessage: "No posts here yet.",
          fullWireLink: "#/group_posts",
          callback: function() { self.displayPreviews(); }
        }))
      ];
    }
    return this._wires;
  },
  
  displayPreviews: function() {
    this._sortCountdown++;
    
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
        
        var self = this;
        _.each(sorted, function(wire) {
          wire.el.detach();
          self.$(".populated").append(wire.el);
        });
        
        if (Features.isActive("chronoResource")) {
          this._chrono = new PaginatingWire({
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
      }
    }
  } 
});

var LandingPreview = PaginatingWire.extend({
  template: "wires.preview-wire",
  _defaultPerPage: 3,
  fullWireLink: function() { return this.options.fullWireLink; },
  showMore: function() {},
  areMore: function() { return false; },
  isRecent: function() { return true; }
});
