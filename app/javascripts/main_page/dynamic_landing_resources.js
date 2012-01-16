var DynamicLandingResources = CommonPlace.View.extend({
  template: "main_page.dynamic-landing-resources",
  className: "resources",
  
  initialize: function() {
    this.raw = new CommunityWire({ uri: CommonPlace.community.link("landing_wires")});
    this.postlikes = new PostLikes([], { uri: CommonPlace.community.link("post_likes") });
    this._wires = [];
  },
  
  resources: function(callback) {
    var self = this;
    
    if (this.currentQuery) {
      this.postlikes.fetch({ query: this.currentQuery }, function() {
        self.makeSearch();
        self.resources(callback);
      });
    } else if (_.isEmpty(this._wires)) {
      this.raw.fetch({}, function() {
        self.makeWires();
        self.resources(callback);
      });
    } else {
      if (!this._wires.length) { console.log("what"); }
      _.each(this._wires, function(wire) { callback(wire); });
    }
  },
  
  makeWires: function() {
    var self = this;
    var unfiltered = [
      (new LandingPreview({
        template: "main_page.post-resources",
        collection: self.raw.neighborhood,
        fullWireLink: "#/posts",
        emptyMessage: "No posts here yet."
      })),
      (new LandingPreview({
        template: "main_page.post-offer-resources",
        collection: self.raw.offers,
        fullWireLink: "#/posts",
        emptyMessage: "No offers here yet."
      })),
      (new LandingPreview({
        template: "main_page.post-help-resources",
        collection: self.raw.help,
        fullWireLink: "#/posts",
        emptyMessage: "No help requests here yet."
      })),
      (new LandingPreview({
        template: "main_page.post-publicity-resources",
        collection: self.raw.publicity,
        fullWireLink: "#/posts",
        emptyMessage: "No posts here yet."
      })),
      (new LandingPreview({
        template: "main_page.post-other-resources",
        collection: self.raw.other,
        fullWireLink: "#/posts",
        emptyMessage: "No posts here yet."
      })),
      (new LandingPreview({
        template: "main_page.announcement-resources",
        collection: self.raw.announcements,
        fullWireLink: "#/announcements",
        emptyMessage: "No announcements here yet."
      })),
      (new LandingPreview({
        template: "main_page.group-post-resources",
        collection: self.raw.groupPosts,
        fullWireLink: "#/groupPosts",
        emptyMessage: "No posts here yet."
      }))
    ];
    
    var duplicates = [];
    var sorted = _.filter(unfiltered, function(wire) {
      return wire.collection.length > 0;
    });
    
    var empty = _.filter(unfiltered, function(wire) {
      return !wire.collection.length;
    });
    
    sorted = _.sortBy(sorted, function(wire) {
      return parseDate(wire.collection.first().get("published_at"));
    });
    
    sorted.reverse();
    
    var first = sorted.shift();
    
    var events = new LandingPreview({
      template: "main_page.event-resources",
      collection: self.raw.events,
      fullWireLink: "#/events",
      emptyMessage: "No events here yet."
    });
    
    var chrono = new Wire({
      template: "main_page.chrono-resources",
      collection: CommonPlace.community.postlikes,
      emptyMessage: "No posts here yet.",
      perPage: 22
    });
    
    _.each(self.raw.all(), function(collection) { duplicates.push(collection.models); })
    chrono.collection.setDupes(_.flatten(duplicates));
    
    self._wires = [];
    self._wires.push(first);
    self._wires.push(events)
    self._wires.push(sorted);
    self._wires.push(empty);
    self._wires.push(chrono);
    self._wires = _.flatten(self._wires);
  },
  
  makeSearch: function() {
    var searchWire = new Wire({
      template: "main_page.chrono-resources",
      collection: this.postlikes,
      emptyMessage: "No results.",
      perPage: 22
    });
    this._wires = [];
    this._wires.push(searchWire);
  },
  
  search: function(query) { this.currentQuery = query; },
  
  cancelSearch: function() { this.currentQuery = ""; }
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
