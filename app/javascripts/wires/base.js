var Wire = CommonPlace.View.extend({
  className: "wire",
  template: "wires/wire",

  initialize: function(options) { 
    if ($.isFunction(options.modelToView)) {
      this.modelToView = options.modelToView;
    }

    this.scope['limit'] = this.perPage();
    this.scope['page'] = this.currentPage();

    this.aroundRender = this.fetchPage;
    this.afterRender = this.appendPage;
  },

  modelToView: function() {
    throw new Error("This is an abstract class, use a child of this class");
  },

  scope: {},

  fetchPage: function(callback) {
    this.collection.fetch({
      data: this.scope,
      success: callback
    });
  },

  appendPage: function(collection, response) {
    var self = this;
    var $ul = this.$("ul.wire-list");
    this.collection.each(function(model) {
      $ul.append(self.modelToView(model).render().el);
    });
  },

  
  isEmpty: function() {
    return this.collection.isEmpty();
  },

  emptyMessage: function() {
    return this.options.emptyMessage;
  },
    
  showMore: function(event) {
    alert('foo');
    var self = this;
    event.preventDefault();
    this.nextPage();
    this.fetchPage(function() { self.appendPage() });
  },

  currentPage: function() {
    return 0;
  },

  perPage: function() {
    return 0;
  }

});
