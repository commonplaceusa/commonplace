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
  
  onScroll: function() {
  
    var isOnScreen = function($el) {
      var $window = $(window);
      if ($($el).length < 1) { return false; }
      return $window.scrollTop() + $window.height() > $el.offset().top
      && $window.scrollTop() < $el.offset().top + $el.height();
    }
  
    var $end = this.$(".end");
    if (isOnScreen($end) && this.$(".loading:visible").length < 1) {
      this.$(".loading").show();
      this.showMore();
    }
  },
  
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
    "click form.search input.complete": "cancelSearch"
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
    this.currentQuery = $input.val();
    this.$("ul").empty();
    $input.removeClass("complete").addClass("waiting");
    var self = this;
    this.fetchCurrentPage(function() { 
      self.appendCurrentPage(); 
      $input.removeClass("waiting");
      if ($input.val() !== "") { $input.addClass("complete"); }
    });
  },

  cancelSearch: function(e) { 
    if (e.offsetX < 20) { // clicked on icon
      this.$("form.search input").val("");
      this.search();
    }      
  },

  isSearchEnabled: function() { return this.isActive('wireSearch');  }

});
