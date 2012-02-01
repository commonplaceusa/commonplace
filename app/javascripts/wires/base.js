var Wire = CommonPlace.View.extend({
  className: "wire",
  template: "wires/wire",

  initialize: function(options) { this.options.showProfile = this.options.showProfile || $.noop; },
  
  aroundRender: function(render) {
    var self = this;
    this.fetchCurrentPage(function() { render(); });
  },

  afterRender: function() {
    var self = this;
    
    this.appendCurrentPage();
    
    this.header = this.$(".sub-navigation");
    
    $(window).scroll(function() { self.onScroll(); });

    CommonPlace.layout && CommonPlace.layout.reset();
    
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

    if (isOnScreen($end) && this.$(".loading:visible").length < 1) {
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
      var view = self.schemaToView(model);
      $ul.append(view.render().el);
      if (self.currentQuery) {
        _.each(self.currentQuery.split(" "), function(query) {
          view.$(".title").highlight(query);
          view.$(".author").highlight(query);
          view.$(".body").highlight(query);
        });
      }
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
    }[schema]({model: model, showProfile: this.options.showProfile });
  },
  
  isEmpty: function() { return this.collection.isEmpty(); },

  emptyMessage: function() { return this.options.emptyMessage; },

  showMore: function(e) {
    var self = this;
    e && e.preventDefault();
    this.nextPage();
    this.fetchCurrentPage(function() { self.appendCurrentPage(); });
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
  
  search: function(query) { this.currentQuery = query; },
  
  cancelSearch: function() {
    $(this.el).removeHighlight();
    this.currentQuery = "";
  },

  isSearchEnabled: function() { return this.isActive('2012Release');  }

});
