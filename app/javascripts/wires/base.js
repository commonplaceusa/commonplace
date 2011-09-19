var Wire = CommonPlace.View.extend({
  className: "wire",
  template: "wires/wire",

  events: {
    "click a.more": "showMore"
  },

  initialize: function(options) { 
    this.account = options.account;
  },

  aroundRender: function(render) {
    var self = this;
    this.fetchCurrentPage(function() {
      render();
    });
  },

  afterRender: function() { this.appendCurrentPage(); },

  modelToView: function() { 
    throw new Error("This is an abstract class, use a child of this class");
  },

  fetchCurrentPage: function(callback) {
    this.collection.fetch({
      data: { limit: this.perPage(), page: this.currentPage() },
      success: callback
    });
  },

  appendCurrentPage: function() {
    var self = this;
    var $ul = this.$("ul.wire-list");
    this.collection.each(function(model) {
      $ul.append(self.modelToView(model).render().el);
    });
  },

  areMore: function() {
    return !(this.collection.length < this.perPage());
  },

  isEmpty: function() {
    return this.collection.isEmpty();
  },

  emptyMessage: function() {
    throw new Error("This is an abstract class, use a child of this class");
  },
    
  showMore: function(e) {
    var self = this;
    e.preventDefault();
    this.nextPage();
    this.fetchCurrentPage(function() { self.appendCurrentPage(); });
  },

  currentPage: function() {
    return (this._currentPage || this.options.currentPage || 0);
  },

  perPage: function() {
    return (this.options.perPage || 10);
  },

  nextPage: function() {
    this._currentPage = (this._currentPage || this.options.currentPage || 0) + 1;
  }
});