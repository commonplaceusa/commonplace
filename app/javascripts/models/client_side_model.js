var ClientSideModel = Backbone.Model.extend({
  fetch: function(o) { o.success(this) }
});
