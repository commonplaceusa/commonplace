
var CommunityResources = CommonPlace.View.extend({
  template: "main_page.community-resources",
  id: "community-resources",
  
  events: {
    "submit .sticky form": "search",
    "keyup .sticky input": "debounceSearch",
    "click .sticky .cancel": "cancelSearch",
    "mouseenter": "showProfile",
    "mouseenter .post": "showProfile",
    "mouseenter .thank-share": "showProfile"
  },
  
  afterRender: function() {
    var self = this;
    this.searchForm = new this.SearchForm();
    this.searchForm.render();
    $(this.searchForm.el).prependTo(this.$(".sticky"));
    $(window).on("scroll.communityLayout", function() { self.stickHeader(true); });
    this.$("[placeholder]").placeholder();
  },

  switchTab: function(tab, single) {
    var self = this;
    
    this.$(".tab-button").removeClass("current");
    this.$("." + tab).addClass("current");

    this.view = this.tabs[tab](this);
    
    this.$(".search-switch").removeClass("active");
    if (_.include(["users", "groups", "feeds"], tab)) {
      this.$(".directory-search").addClass("active");
    } else {
      this.$(".post-search").addClass("active");
    }
    
    if (single) { this.view.singleWire(single); }
    
    (self.currentQuery) ? self.search() : self.showTab();
  },

  winnowToCollection: function(collection_name) {
    var self = this;

    this.view = this.tabs[collection_name](this);
    this.$(".search-switch").removeClass("active");

    if (_.include([], collection_name)) {
      this.$(".post-search").addClass("active");
    }

    (self.currentQuery) ? self.search() : self.showTab();
  },
  
  showTab: function() {
    this.$(".resources").empty();
    this.$(".resources").append(this.loading());
    var self = this;
    
    this.view.resources(function(wire) {
      wire.render();
      $(wire.el).appendTo(self.$(".resources"));
    });
    
    this.stickHeader(true);
  },
  
  tabs: {
    all_posts: function(self) {
      return new DynamicLandingResources({
        callback: function() { self.stickHeader(); },
        showProfile: self.options.showProfile
      });
    },
    
    posts: function(self) {
      var wire = new self.PostLikeWire({
        template: "main_page.post-resources",
        emptyMessage: "No posts here yet.",
        collection: CommonPlace.community.postsAndGroupPosts,
        callback: function() { self.stickHeader(); },
        showProfile: self.options.showProfile,
        isInAllWire: true
      });
      return self.makeTab(wire);
    },

    neighborhood: function(self) {
      var wire = new self.PostLikeWire({
        template: "main_page.post-resources",
        emptyMessage: "No posts here yet.",
        collection: CommonPlace.community.categories["neighborhood"],
        callback: function() { self.stickHeader(); },
        showProfile: self.options.showProfile
      });
      return self.makeTab(wire);
    },

    help: function(self) {
      var wire = new self.PostLikeWire({
        template: "main_page.post-resources",
        emptyMessage: "No posts here yet.",
        collection: CommonPlace.community.categories["help"],
        callback: function() { self.stickHeader(); },
        showProfile: self.options.showProfile
      });
      return self.makeTab(wire);
    },

    offers: function(self) {
      var wire = new self.PostLikeWire({
        template: "main_page.post-resources",
        emptyMessage: "No posts here yet.",
        collection: CommonPlace.community.categories["offers"],
        callback: function() { self.stickHeader(); },
        showProfile: self.options.showProfile
      });
      return self.makeTab(wire);
    },

    publicity: function(self) {
      var wire = new self.PostLikeWire({
        template: "main_page.post-resources",
        emptyMessage: "No posts here yet.",
        collection: CommonPlace.community.categories["publicity"],
        callback: function() { self.stickHeader(); },
        showProfile: self.options.showProfile
      });
      return self.makeTab(wire);
    },

    meetup: function(self) {
      var wire = new self.PostLikeWire({
        template: "main_page.post-resources",
        emptyMessage: "No posts here yet.",
        collection: CommonPlace.community.categories["meetups"],
        callback: function() { self.stickHeader(); },
        showProfile: self.options.showProfile
      });
      return self.makeTab(wire);
    },

    other: function(self) {
      var wire = new self.PostLikeWire({
        template: "main_page.post-resources",
        emptyMessage: "No posts here yet.",
        collection: CommonPlace.community.categories["other"],
        callback: function() { self.stickHeader(); },
        showProfile: self.options.showProfile
      });
      return self.makeTab(wire);
    },
    
    events: function(self) {
      var wire = new self.PostLikeWire({
        template: "main_page.event-resources",
        emptyMessage: "No events here yet.",
        collection: CommonPlace.community.events,
        callback: function() { self.stickHeader(); },
        showProfile: self.options.showProfile
      });
      return self.makeTab(wire);
    },
    
    announcements: function(self) {
      var wire = new self.PostLikeWire({
        template: "main_page.announcement-resources",
        emptyMessage: "No announcements here yet.",
        collection: CommonPlace.community.announcements,
        callback: function() { self.stickHeader(); },
        showProfile: self.options.showProfile
      });
      return self.makeTab(wire);
    },
    
    group_posts: function(self) {
      var wire = new self.PostLikeWire({
        template: "main_page.group-post-resources",
        emptyMessage: "No posts here yet.",
        collection: CommonPlace.community.groupPosts,
        callback: function() { self.stickHeader(); },
        showProfile: self.options.showProfile
      });
      return self.makeTab(wire);
    },
    
    groups: function(self) {
      var wire = new self.GroupLikeWire({
        template: "main_page.directory-resources",
        emptyMessage: "No groups here yet.",
        collection: CommonPlace.community.groups,
        callback: function() { self.stickHeader(); },
        active: "groups",
        showProfile: self.options.showProfile
      });
      return self.makeTab(wire);
    },
    
    feeds: function(self) {
      var wire = new self.GroupLikeWire({
        template: "main_page.directory-resources",
        emptyMessage: "No feeds here yet.",
        collection: CommonPlace.community.feeds,
        callback: function() { self.stickHeader(); },
        active: "feeds",
        showProfile: self.options.showProfile
      });
      return self.makeTab(wire);
    },
    
    users: function(self) {
      var wire = new self.GroupLikeWire({
        template: "main_page.directory-resources",
        emptyMessage: "No users here yet.",
        collection: CommonPlace.community.users,
        callback: function() { self.stickHeader(); },
        active: "users",
        showProfile: self.options.showProfile
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
  
  highlightSingleUser: function(user) { this.singleUser = user; },
  
  showSingleItem: function(model, kind, options) {
    this.model = model;
    var self = this;
    var wire = new LandingPreview({
      template: options.template,
      collection: new kind([model], { uri: model.link("self") }),
      fullWireLink: options.fullWireLink,
      callback: function() { self.stickHeader(); }
    });
    if (!_.isEmpty(this.singleUser)) {
      wire.searchUser(this.singleUser);
      this.singleUser = {};
    }
    this.switchTab(options.tab, wire);
    $(window).scrollTo(0);
  },

  showProfile: function(e) {
    var user = new User({
      links: { self: this.model.link("author") }
    });
    this.options.showProfile(user);
  },
  
  showUserWire: function(user) {
    var self = this;
    user.fetch({ success: function() {
      var collection = new PostLikes([], { uri: user.link("postlikes") });
      var wire = new Wire({
        template: "main_page.user-wire-resources",
        collection: collection,
        emptyMessage: "No posts here yet.",
        callback: function() { self.stickHeader(); }
      });
      wire.searchUser(user);
      self.switchTab("all_posts", wire);
      $(window).scrollTo(0);
    }});
  },
  
  debounceSearch: _.debounce(function() {
    this.search();
  }, CommonPlace.autoActionTimeout),
  
  search: function(event) {
    if (event) { event.preventDefault(); }
    this.currentQuery = this.$(".sticky form .search-switch.active input").val();
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
  
  stickHeader: function(isFirst) {
    var $sticky_header = this.$(".sticky .header");
    var sticky_bottom = $sticky_header.offset().top + $sticky_header.outerHeight();
    
    if (!isFirst) { this.$(".resources .loading-resource").remove(); }
    
    var current_subnav = this.$(".resources .sub-navigation").filter(function() {
      if (!$sticky_header.height()) {
        return $(this).offset().top <= $sticky_header.offset().top;
      } else {
        var $nav_text = $(this).children("h2");
        var nav_text_bottom = $nav_text.offset().top + $nav_text.height();
        return nav_text_bottom <= sticky_bottom;
      }
    }).last();
    
    $sticky_header.html(current_subnav.clone());
    
    if (this.currentQuery) { $(".sticky .cancel").removeClass("waiting"); }
    
    CommonPlace.layout.reset();
  },
  
  makeTab: function(wire) { return new this.ResourceTab({ wire: wire }); },
  
  loading: function() {
    var view = new this.LoadingResource();
    view.render();
    return view.el;
  },
  
  PostLikeWire: Wire.extend({ _defaultPerPage: 15 }),
  
  GroupLikeWire: Wire.extend({ _defaultPerPage: 50 }),
  
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
    
    singleWire: function(wire) { this.single = wire; },
    
    cancelSearch: function() { this.search(""); }
  }),

  SearchForm: CommonPlace.View.extend({
    template: "main_page.community-search-form",
    tagName: "form",
    className: "search"
  }),
  
  LoadingResource: CommonPlace.View.extend({
    template: "main_page.loading-resource",
    className: "loading-resource"
  })
  
});

