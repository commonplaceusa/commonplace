var DynamicLandingResources = CommonPlace.View.extend({
  template: "main_page.dynamic-landing-resources",
  className: "resources",
  
  afterRender: function() {
    this._sortCountdown = 0;
    // fetch the collections
    // remove the top three posts from each
    // if there are no posts, shunt that collection's previewwire in an emptybox
    // sort the three-collections by date of first post's reply or first post
    // render and append those three-collections
    // fetch the chrono collection for the bottom
    // remove all posts in three-collections from the chrono
    // append the chrono to the bottom
    // when we hit bottom, add to the chrono while removing all posts in three-collections
    
    //this.chrono = new PaginatingWire();
    
    var self = this;
    
    this._events = new LandingPreview({
      template: 'main_page.event-resources',
      collection: CommonPlace.community.events,
      el: this.$(".events.wire"),
      fullWireLink: "#/events",
      emptyMessage: "There are no upcoming events yet. Add some.",
      modelToView: function(model) {
        return new EventWireItem({ model: model, account: CommonPlace.account });
      }
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
          callback: function() { self.displayPreviews(); },
          modelToView: function(model) {
            return new PostWireItem({ model: model, account: CommonPlace.account });
          }
        })),
        
        (new LandingPreview({
          template: 'main_page.post-offer-resources',
          collection: CommonPlace.community.categories.offers,
          el: this.$(".offerPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No offers here yet.",
          callback: function() { self.displayPreviews(); },
          modelToView: function(model) {
            return new PostWireItem({ model: model, account: CommonPlace.account });
          }
        })),
        
        (new LandingPreview({
          template: 'main_page.post-help-resources',
          collection: CommonPlace.community.categories.help,
          el: this.$(".helpPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No help requests here yet.",
          callback: function() { self.displayPreviews(); },
          modelToView: function(model) {
            return new PostWireItem({ model: model, account: CommonPlace.account });
          }
        })),
        
        (new LandingPreview({
          template: 'main_page.post-publicity-resources',
          collection: CommonPlace.community.categories.publicity,
          el: this.$(".publicityPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No posts here yet.",
          callback: function() { self.displayPreviews(); },
          modelToView: function(model) {
            return new PostWireItem({ model: model, account: CommonPlace.account });
          }
        })),
        
        (new LandingPreview({
          template: 'main_page.post-other-resources',
          collection: CommonPlace.community.categories.other,
          el: this.$(".otherPosts.wire"),
          fullWireLink: "#/posts",
          emptyMessage: "No posts here yet.",
          callback: function() { self.displayPreviews(); },
          modelToView: function(model) {
            return new PostWireItem({ model: model, account: CommonPlace.account });
          }
        })),
        
        (new LandingPreview({
          template: 'main_page.announcement-resources',
          collection: CommonPlace.community.announcements,
          el: this.$(".announcements.wire"),
          emptyMessage: "No announcements here yet.",
          fullWireLink: "#/announcements",
          callback: function() { self.displayPreviews(); },
          modelToView: function(model) {
            return new AnnouncementWireItem({ model: model, account: CommonPlace.account });
          }
        })),
        
        (new LandingPreview({
          template: 'main_page.group-post-resources',
          collection: CommonPlace.community.groupPosts,
          el: this.$(".groupPosts.wire"),
          emptyMessage: "No posts here yet.",
          fullWireLink: "#/group_posts",
          callback: function() { self.displayPreviews(); },
          modelToView: function(model) {
            return new GroupPostWireItem({ model: model, account: CommonPlace.account });
          }
        }))
      ];
    }
    return this._wires;
  },
  
  displayPreviews: function() {
    this._sortCountdown++;
    
    if (this._sortCountdown++ == this._wires.length) {
      var sorted = _.filter(this._wires, function(wire) { return wire.collection.length > 0; });
      
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
