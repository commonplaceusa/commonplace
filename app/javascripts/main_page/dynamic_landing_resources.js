var DynamicLandingResources = CommonPlace.View.extend({
  template: "main_page.dynamic-landing-resources",
  className: "resources",
  
  initialize: function(options) {
    this.raw = new CommunityWire({ uri: CommonPlace.community.link("landing_wires")});
    this.postlikes = new PostLikes([], { uri: CommonPlace.community.link("post_likes") });
    this._wires = [];
    this.single = {};
    this.callback = options.callback;
  },
  
  resources: function(callback) {
    var self = this;
    
    if (!_.isEmpty(this.single) && !this.currentQuery) {
      callback(this.single);
    } else if (_.isEmpty(this._wires)) {
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
        template: "main_page.post-neighborhood-resources",
        collection: self.raw.neighborhood,
        emptyMessage: "No posts here yet.",
        callback: self.callback,
      })),
      (new LandingPreview({
        template: "main_page.post-offer-resources",
        collection: self.raw.offers,
        emptyMessage: "No offers here yet.",
        callback: self.callback,
      })),
      (new LandingPreview({
        template: "main_page.post-help-resources",
        collection: self.raw.help,
        emptyMessage: "No help requests here yet.",
        callback: self.callback,
      })),
      (new LandingPreview({
        template: "main_page.post-publicity-resources",
        collection: self.raw.publicity,
        emptyMessage: "No posts here yet.",
        callback: self.callback,
      })),
      (new LandingPreview({
        template: "main_page.post-other-resources",
        collection: self.raw.other,
        emptyMessage: "No posts here yet.",
        callback: self.callback,
      })),
      (new LandingPreview({
        template: "main_page.group-post-resources",
        collection: self.raw.groupPosts,
        emptyMessage: "No posts here yet.",
        callback: self.callback,
      })),
      (new LandingPreview({
        template: "main_page.post-meetup-resources",
        collection: self.raw.meetups,
        emptyMessage: "No meetups here yet.",
        callback: self.callback,
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
      emptyMessage: "No events here yet.",
      callback: self.callback,
    });
   
    var transactions = new LandingPreview({
      template: "main_page.transaction-resources",
      collection: self.raw.transactions,
      emptyMessage: "No items here yet.",
      callback: self.callback,
    });
 
    var chrono = new Wire({
      template: "main_page.chrono-resources",
      collection: CommonPlace.community.postlikes,
      emptyMessage: "No posts here yet.",
      perPage: 22,
      callback: self.callback,
    });
    
    _.each(self.raw.all(), function(collection) { duplicates.push(collection.models); })
    chrono.collection.setDupes(_.flatten(duplicates));
    
    self._wires = [first];
    self._wires.push(sorted);
    if (transactions.collection.length) { self._wires.push(transactions); }
    if (events.collection.length) { self._wires.push(events); }
    self._wires.push(chrono);
    self._wires = _.flatten(self._wires);
  },
  
  makeSearch: function() {
    var searchWire = new Wire({
      template: "main_page.chrono-search-resources",
      collection: this.postlikes,
      emptyMessage: "No results.",
      perPage: 22,
      callback: this.callback,
    });
    searchWire.search(this.currentQuery);
    this._wires = [searchWire];
  },
  
  search: function(query) {
    this.currentQuery = query;
    this._wires = [];
    this.single = {};
  },
  
  cancelSearch: function() { this.search(""); },
  
  singleWire: function(wire) { this.single = wire; }
});

var LandingPreview = PreviewWire.extend({
  template: "wires.preview-wire",
  _defaultPerPage: 3,
  aroundRender: function(render) { render(); },
  showMore: function() {},
  areMore: function() { return false; },
  isRecent: function() { return true; }
});
