var PaginatingWire = Wire.extend({
  template: "wires/wire",

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
    mpq.track('wire-search', {query: this.currentQuery})
  },

  isSearchEnabled: function() { return this.isActive('wireSearch');  }

});
