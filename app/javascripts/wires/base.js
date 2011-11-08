var Wire = CommonPlace.View.extend({
  className: "wire",
  template: "wires/wire",

  initialize: function(options) { 
    if ($.isFunction(options.modelToView)) {
      this.modelToView = options.modelToView;
    }
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
      $ul.append(self.modelToView(model).render().el);
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

  currentPage: function() {
    return 0;
  },

  perPage: function() {
    return 0;
  }

});
