var Wire = CommonPlace.View.extend({
  className: "wire",
  template: "wires/wire",

  initialize: function(options) {},
  
  aroundRender: function(render) {
    var self = this;
    this.fetchCurrentPage(function() {
      console.log("is this being called in the searches that work?");
      render();
    });
  },

  afterRender: function() {
    var self = this;
    
    this.appendCurrentPage();
    
    this.header = this.$(".sub-navigation");
    
    this.header.find("form.search").bind("keyup", function() { self.debounceSearch(); });
    this.header.find("form.search input").bind("submit", function() { self.search(); });
    this.header.find("form.search .cancel").bind("click", function() { self.cancelSearch(); });
    
    $(window).scroll(function() { self.onScroll(); });
    
    this.options.callback && this.options.callback();
  },
  
  onScroll: _.debounce(function() {
  
    var isOnScreen = function($el) {
      if ($el.length < 1) { return false; }
      var $window = $(window);
      var windowOffset = $(window).scrollTop();
      var elOffset = $el.offset().top;

      return (elOffset < $window.scrollTop() + $window.height() &&
              $window.scrollTop() < elOffset + $el.height());
    };
  
    var $end = this.$(".end");

    // Autoloading pages is limited to 3 pages until we figure out how to
    // make links in the footer accessible
    if (isOnScreen($end) && this.$(".loading:visible").length < 1 && this.currentPage() < 3) {
      this.$(".loading").show();
      this.showMore();
    }
  }, CommonPlace.autoActionTimeout),
  
  fetchCurrentPage: function(callback) {
    var data = { limit: this.perPage(), page: this.currentPage() };
    if (this.currentQuery) { data.query = this.currentQuery; }
    
    var self = this;
    this.collection.fetch({
      data: data,
      success: callback,
      error: function(a, b) {
        self.$(".loading").text("Sorry, couldn't load.");
      }
    });
  },

  appendCurrentPage: function() {
    this.$(".loading").hide();
    var self = this;
    var $ul = this.$("ul.wire-list");
    this.collection.each(function(model) {
      $ul.append(self.schemaToView(model).render().el);
    });
  },
  
  schemaToView: function(model) {
    var schema = model.get("schema");
    return new {
      "events": EventWireItem,
      "announcements": AnnouncementWireItem,
      "posts": PostWireItem,
      "group_posts": GroupPostWireItem,
      "feeds": FeedWireItem,
      "users": UserWireItem,
      "groups": GroupWireItem
    }[schema]({model: model});
  },
  
  isEmpty: function() { return this.collection.isEmpty(); },

  emptyMessage: function() { return this.options.emptyMessage; },

  showMore: function(e) {
    var self = this;
    e && e.preventDefault();
    this.nextPage();
    this.fetchCurrentPage(function() { self.appendCurrentPage(); });
  },
  
  events: {
    "keyup form.search input": "debounceSearch",
    "submit form.search": "search",
    "click form.search .cancel": "cancelSearch"
  },

  currentPage: function() {
    return (this._currentPage || this.options.currentPage || 0);
  },

  areMore: function() {
    return this.collection.length >= this.perPage();
  },

  _defaultPerPage: 10,

  perPage: function() {
    return (this.options.perPage || this._defaultPerPage);
  },

  nextPage: function() {
    this._currentPage = this.currentPage() + 1;
  },

  debounceSearch: _.debounce(function() {
    this.search();
  }, CommonPlace.autoActionTimeout),

  query: "",

  search: function(event) {
    if (event) { event.preventDefault(); }
    var $input = this.header.find("form.search input");
    var $cancel = this.header.find("form.search .cancel");
    this.currentQuery = $input.val();
    this.$("ul").empty();
    $cancel.addClass("waiting").show();
    var self = this;
    this.fetchCurrentPage(function() { 
      self.appendCurrentPage(); 
      $cancel.removeClass("waiting");
      if ($input.val() == "") { $cancel.hide(); }
      if (self.collection.length == 0) { self.$(".no-results").show(); }
      else { self.$(".no-results").hide(); }
    });
  },

  cancelSearch: function(e) {
    this.header.find("form.search input").val("");
    this.header.find("form.search .cancel").hide();
    this.search();
  },

  isSearchEnabled: function() { return this.isActive('2012Release');  }

});
