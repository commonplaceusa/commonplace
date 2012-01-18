var DynamicLandingResources = CommonPlace.View.extend({
  template: "main_page.dynamic-landing-resources",
  className: "resources",
  
  initialize: function(options) {
    this.raw = new CommunityWire({ uri: CommonPlace.community.link("landing_wires")});
    this.postlikes = new PostLikes([], { uri: CommonPlace.community.link("post_likes") });
    this._wires = [];
    this.callback = options.callback;
  },
  
  resources: function(callback) {
    var self = this;
    
    if (_.isEmpty(this._wires)) {
      if (this.currentQuery) {
        this.postlikes.fetch({
          data: { query: this.currentQuery },
          success: function() {
            self.makeSearch();
            self.resources(callback);
          }
        });
      } else {
        this.raw.fetch({}, function() {
          self.makeWires();
          self.resources(callback);
        });
      }
    } else {
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
        emptyMessage: "No posts here yet.",
        callback: self.callback
      })),
      (new LandingPreview({
        template: "main_page.post-offer-resources",
        collection: self.raw.offers,
        fullWireLink: "#/posts",
        emptyMessage: "No offers here yet.",
        callback: self.callback
      })),
      (new LandingPreview({
        template: "main_page.post-help-resources",
        collection: self.raw.help,
        fullWireLink: "#/posts",
        emptyMessage: "No help requests here yet.",
        callback: self.callback
      })),
      (new LandingPreview({
        template: "main_page.post-publicity-resources",
        collection: self.raw.publicity,
        fullWireLink: "#/posts",
        emptyMessage: "No posts here yet.",
        callback: self.callback
      })),
      (new LandingPreview({
        template: "main_page.post-other-resources",
        collection: self.raw.other,
        fullWireLink: "#/posts",
        emptyMessage: "No posts here yet.",
        callback: self.callback
      })),
      (new LandingPreview({
        template: "main_page.announcement-resources",
        collection: self.raw.announcements,
        fullWireLink: "#/announcements",
        emptyMessage: "No announcements here yet.",
        callback: self.callback
      })),
      (new LandingPreview({
        template: "main_page.group-post-resources",
        collection: self.raw.groupPosts,
        fullWireLink: "#/groupPosts",
        emptyMessage: "No posts here yet.",
        callback: self.callback
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
      emptyMessage: "No events here yet.",
      callback: self.callback
    });
    
    var chrono = new Wire({
      template: "main_page.chrono-resources",
      collection: CommonPlace.community.postlikes,
      emptyMessage: "No posts here yet.",
      perPage: 22,
      callback: self.callback
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
      perPage: 22,
      callback: this.callback
    });
    searchWire.search(this.currentQuery);
    this._wires = [];
    this._wires.push(searchWire);
  },
  
  search: function(query) {
    this.currentQuery = query;
    this._wires = [];
  },
  
  cancelSearch: function() { this.search(""); }
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
