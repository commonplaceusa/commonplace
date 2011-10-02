var PaginatingWire = Wire.extend({
  template: "wires/wire",

  events: {
    "click a.more": "showMore"
  },

  currentPage: function() { 
    return (this._currentPage || this.options.currentPage || 0);
  },
  
  areMore: function() {
    return this.collection.length >= this.perPage();
  },
   
  perPage: function() {
    return (this.options.perPage || 10);
  },

  nextPage: function() {
    this._currentPage = (this._currentPage || this.options.currentPage || 0) + 1;
  }

});
