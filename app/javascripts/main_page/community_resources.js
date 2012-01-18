
var CommunityResources = CommonPlace.View.extend({
  template: "main_page.community-resources",
  id: "community-resources",
  
  events: {
    "submit .sticky form": "search",
    "keyup .sticky input": "debounceSearch"
  },
  
  afterRender: function() {
    var self = this;
    this.searchForm = new self.SearchForm();
    this.searchForm.render();
    $(this.searchForm.el).prependTo(this.$(".sticky"));
    $(window).scroll(function() { self.stickHeader(); });
  },

  switchTab: function(tab) {
    var self = this;
    
    this.$(".tab-button").removeClass("current");
    this.$("." + tab).addClass("current");

    this.view = this.tabs[tab](this);
    
    (self.currentQuery) ? self.search() : self.showTab();
  },
  
  showTab: function() {
    this.$(".resources").empty();
    this._ready = false;
    this.countdown = 0;
    this.count = 0;
    var self = this;
    
    this.view.resources(function(wire) {
      self.count++;
      wire.render();
      if (self.currentQuery) { $(wire.el).highlight(self.currentQuery); }
      $(wire.el).appendTo(self.$(".resources"));
    });
  },
  
  tabs: {
    landing: function(self) {
      return new DynamicLandingResources({
        callback: function() { self.stickHeader(); }
      });
    },
    
    posts: function(self) {
      var wire = new self.ResourceWire({
        template: "main_page.post-resources",
        emptyMessage: "No posts here yet.",
        collection: CommonPlace.community.posts,
        callback: function() { self.stickHeader(); }
      });
      return self.makeTab(wire);
    },
    
    events: function(self) {
      var wire = new self.ResourceWire({
        template: "main_page.event-resources",
        emptyMessage: "No events here yet.",
        collection: CommonPlace.community.events,
        callback: function() { self.stickHeader(); }
      });
      return self.makeTab(wire);
    },
    
    announcements: function(self) {
      var wire = new self.ResourceWire({
        template: "main_page.announcement-resources",
        emptyMessage: "No announcements here yet.",
        collection: CommonPlace.community.announcements,
        callback: function() { self.stickHeader(); }
      });
      return self.makeTab(wire);
    },
    
    group_posts: function(self) {
      var wire = new self.ResourceWire({
        template: "main_page.group-post-resources",
        emptyMessage: "No posts here yet.",
        collection: CommonPlace.community.groupPosts,
        callback: function() { self.stickHeader(); }
      });
      return self.makeTab(wire);
    },
    
    groups: function(self) {
      var wire = new self.ResourceWire({
        template: "main_page.directory-resources",
        emptyMessage: "No groups here yet.",
        collection: CommonPlace.community.groups,
        callback: function() { self.stickHeader(); },
        active: "groups"
      });
      return self.makeTab(wire);
    },
    
    feeds: function(self) {
      var wire = new self.ResourceWire({
        template: "main_page.directory-resources",
        emptyMessage: "No feeds here yet.",
        collection: CommonPlace.community.feeds,
        callback: function() { self.stickHeader(); },
        active: "feeds"
      });
      return self.makeTab(wire);
    },
    
    users: function(self) {
      var wire = new self.ResourceWire({
        template: "main_page.directory-resources",
        emptyMessage: "No users here yet.",
        collection: CommonPlace.community.users,
        callback: function() { self.stickHeader(); },
        active: "users"
      });
      return self.makeTab(wire);
    }
  },
  
  // single item view overhaul is yet to be determined

  /**showPost: function(post) {
    this.showSingleItem(post, GroupPostWireItem);
  },
  showAnnouncement: function(announcement) {
    this.showSingleItem(announcement, AnnouncementWireItem);
  },
  showEvent: function(event) {
    this.showSingleItem(event, EventWireItem);
  },
  showGroupPost: function(groupPost) {
    this.showSingleItem(groupPost, GroupPostWireItem);
  },

  showSingleItem: function(model, ItemView) {
    var self = this;
    model.fetch({
      success: function(model) {
        var item = new ItemView({model: model, account: self.options.account});

        self.$(".tab-button").removeClass("current");

        item.render();

        self.$(".resources").html($("<div/>", { 
          "class": "wire",
          html: $("<ul/>", {
            "class": "wire-list",
            html: item.el
          })
        }));
      }
    });
  }**/
  
  debounceSearch: _.debounce(function() {
    this.search();
  }, CommonPlace.autoActionTimeout),
  
  search: function(event) {
    if (event) { event.preventDefault(); }
    this.currentQuery = this.$(".sticky form.search input").val();
    this.view.search(this.currentQuery);
    this.showTab();
  },
  
  cancelSearch: function(e) {
    this.view.cancelSearch();
    this.showTab();
  },
  
  stickHeader: function(ready) {
    var $sticky_header = this.$(".sticky .header");
    var current_subnav = this.$(".resources .sub-navigation").filter(function() {
      return $(this).offset().top <= $sticky_header.offset().top;
    }).last();

    $sticky_header.html(current_subnav.clone());
  },
  
  makeTab: function(wire) { return new this.ResourceTab({ wire: wire }); },
  
  ResourceWire: Wire.extend({ _defaultPerPage: 15 }),
  
  ResourceTab: CommonPlace.View.extend({
    initialize: function(options) {
      this._wires = [];
      this._wires.push(options.wire);
    },
    
    resources: function(callback) {
      _.each(this._wires, function(wire) { callback(wire); });
    },
    
    search: function(query) {
      _.each(this._wires, function(wire) {
        wire.currentQuery = query;
      });
    },
    
    cancelSearch: function() { this.search(""); }
  }),

  SearchForm: CommonPlace.View.extend({
    template: "main_page.community-search-form",
    tagName: "form",
    className: "search"
  })
  
});

