// a fake collection for group-likes, because the id #'s collide
var GroupLikes = Model.extend({
  initialize: function(blank, options) {
    this.uri = "/api" + options.uri;
  },
  
  fetch: function(options) {
    var self = this;
    $.getJSON(this.uri, options.data, function(data) {
      self.models = _.map(data, function(d) { return self.toModel(d); });
      self.length = data.length;
      options.success && options.success();
    });
  },
  
  each: function(callback) {
    _.each(this.models, function(model) {
      callback(model);
    });
  },
  
  toModel: function(data) {
    var x = new {
      "users": User,
      "feeds": Feed,
      "groups": Group
    }[data.schema](data);
    return x;
  },
  
  length: 0,
  
  isEmpty: function() {
    return this.models.length == 0;
  },
  
  first: function() {
    return _.first(this.models);
  },
  
  at: function(index) {
    return this.models[index];
  }
  
});
