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

  afterRender: function() { this.appendCurrentPage(); },
  
  fetchCurrentPage: function(callback) {
    var data = { limit: this.perPage(), page: this.currentPage() };
    if (this.currentQuery) { data.query = this.currentQuery; }
    
    this.collection.fetch({
      data: data,
      success: callback
    });
  },

  appendCurrentPage: function() {
    var self = this;
    var $ul = this.$("ul.wire-list");
    this.collection.each(function(model) {
      var view = new self.options.itemView({model: model, account: CommonPlace.account, community: CommonPlace.community});
      $ul.append(view.render().el);
    });
  },

  
  isEmpty: function() {
    return this.collection.isEmpty();  },

  emptyMessage: function() {
    return this.options.emptyMessage;
  },
    

  showMore: function(e) {
    var self = this;
    e.preventDefault();
    this.nextPage();
    this.fetchCurrentPage(function() { self.appendCurrentPage(); });
  },
  
  
  
  
  
  
  events: {
    "click a.more": "showMore",
    "keyup form.search input": "debounceSearch",
    "submit form.search": "search"
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
    event.preventDefault();
    this.currentQuery = this.$("form.search input").val();
    this.$("ul").empty();
    var self = this;
    this.fetchCurrentPage(function() { self.appendCurrentPage(); });
  },

  isSearchEnabled: function() { return this.isActive('wireSearch');  }

});
