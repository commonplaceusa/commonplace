var FailedSearch = CommonPlace.View.extend({
  template: "main_page.failed-search",
  className: "failed-search profile",
  
  query: function() { return this.model.get('query'); }
});
