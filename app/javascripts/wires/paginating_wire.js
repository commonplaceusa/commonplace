var PaginatingWire = Wire.extend({
  template: "wires/wire",

  events: {
    "click a.more": "showMore",
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
                    console.log("SEARCH");
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
