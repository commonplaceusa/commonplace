var Wire = CommonPlace.View.extend({
  className: "wire",
  template: "wires/wire",

  initialize: function(options) {},

  aroundRender: function(render) {
    var self = this;
    this.fetchCurrentPage(function() {
      render();
    });
  },

  afterRender: function() {
    this.appendCurrentPage();
    
    var self = this;
    $(window).scroll(function() { self.onScroll(); });
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
      var view = new self.options.itemView({ 
        model: model, 
        account: CommonPlace.account, 
        community: CommonPlace.community
      });
      $ul.append(view.render().el);
    });
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
    this.$("form.search").submit();
  }, CommonPlace.autoActionTimeout),

  query: "",

  search: function(event) {
    if (event) { event.preventDefault(); }
    var $input = this.$("form.search input");
    var $cancel = this.$("form.search .cancel");
    this.currentQuery = $input.val();
    this.$("ul").empty();
    $cancel.addClass("waiting").show();
    var self = this;
    this.fetchCurrentPage(function() { 
      self.appendCurrentPage(); 
      $cancel.removeClass("waiting");
      if ($("form.search input").val() == "") { $cancel.hide(); }
      if (self.collection.length == 0) { self.$(".no-results").show(); }
      else { self.$(".no-results").hide(); }
    });
  },

  cancelSearch: function(e) { 
    this.$("form.search input").val("");
    this.$("form.search .cancel").hide();
    this.search();
  },

  isSearchEnabled: function() { return this.isActive('wireSearch');  }

});
