
var CommunityResources = CommonPlace.View.extend({
  template: "main_page.community-resources",
  id: "community-resources",
  
  events: {
    "submit .sticky form": "search",
    "keyup .sticky input": "debounceSearch",
    "click .sticky .cancel": "cancelSearch"
  },
  
  afterRender: function() {
    var self = this;
    this.searchForm = new self.SearchForm();
    this.searchForm.render();
    $(this.searchForm.el).prependTo(this.$(".sticky"));
    $(window).scroll(function() { self.stickHeader(); });
  },

  switchTab: function(tab, single) {
    var self = this;
    
    this.$(".tab-button").removeClass("current");
    this.$("." + tab).addClass("current");

    this.view = this.tabs[tab](this);
    
    if (single) { this.view.singleItem(single); }
    
    (self.currentQuery) ? self.search() : self.showTab();
  },
  
  showTab: function() {
    this.$(".resources").empty();
    var self = this;
    
    this.view.resources(function(wire) {
      wire.render();
      $(wire.el).appendTo(self.$(".resources"));
    });
    
    this.stickHeader();
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
  
  showPost: function(post) {
    var self = this;
    post.fetch({ success: function() {
      self.showSingleItem(post, Posts, {
        template: "main_page.post-resources",
        fullWireLink: "#/posts",
        tab: "posts"
      });
    }});
  },
  
  showAnnouncement: function(announcement) {
    var self = this;
    announcement.fetch({ success: function() {
      self.showSingleItem(announcement, Announcements, {
        template: "main_page.announcement-resources",
        fullWireLink: "#/announcements",
        tab: "announcements"
      });
    }});
  },
  
  showEvent: function(event) {
    var self = this;
    event.fetch({ success: function() {
      self.showSingleItem(event, Events, {
        template: "main_page.event-resources",
        fullWireLink: "#/events",
        tab: "events"
      });
    }});
  },
  
  showGroupPost: function(post) {
    var self = this;
    post.fetch({ success: function() {
      self.showSingleItem(post, GroupPosts, {
        template: "main_page.group-post-resources",
        fullWireLink: "#/groupPosts",
        tab: "group_posts"
      });
    }});
  },
  
  showSingleItem: function(model, kind, options) {
    var self = this;
    var wire = new LandingPreview({
      template: options.template,
      collection: new kind([model], { uri: model.link("self") }),
      fullWireLink: options.fullWireLink,
      callback: function() { self.stickHeader(); }
    });
    this.switchTab(options.tab, wire);
  },
  
  debounceSearch: _.debounce(function() {
    this.search();
  }, CommonPlace.autoActionTimeout),
  
  search: function(event) {
    if (event) { event.preventDefault(); }
    this.currentQuery = this.$(".sticky form.search input").val();
    if (this.currentQuery) {
      this.view.search(this.currentQuery);
      this.showTab();
      $(".sticky form.search input").addClass("active");
      $(".sticky .cancel").show();
      $(".sticky .cancel").addClass("waiting");
    } else {
      this.cancelSearch();
    }
  },
  
  cancelSearch: function(e) {
    this.currentQuery = "";
    this.$(".sticky form.search input").val("");
    this.view.cancelSearch();
    this.showTab();
    $(".sticky form.search input").removeClass("active");
    $(".sticky .cancel").hide();
    $(".resources").removeHighlight();
  },
  
  stickHeader: function() {
    var $sticky_header = this.$(".sticky .header");
    var current_subnav = this.$(".resources .sub-navigation").filter(function() {
      return $(this).offset().top <= $sticky_header.offset().top;
    }).last();
    $sticky_header.html(current_subnav.clone());
    
    if (this.currentQuery) { $(".sticky .cancel").removeClass("waiting"); }
  },
  
  makeTab: function(wire) { return new this.ResourceTab({ wire: wire }); },
  
  ResourceWire: Wire.extend({ _defaultPerPage: 15 }),
  
  ResourceTab: CommonPlace.View.extend({
    initialize: function(options) {
      this.wire = options.wire;
    },
    
    resources: function(callback) {
      (this.single) ? callback(this.single) : callback(this.wire);
    },
    
    search: function(query) {
      if (this.single) { this.single = null; }
      this.wire.search(query);
    },
    
    singleItem: function(wire) { this.single = wire; },
    
    cancelSearch: function() { this.search(""); }
  }),

  SearchForm: CommonPlace.View.extend({
    template: "main_page.community-search-form",
    tagName: "form",
    className: "search"
  })
  
});

