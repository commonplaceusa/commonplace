// a fake collection for post-likes, because the id #'s collide
var PostLikes = Model.extend({
  initialize: function(models, options) {
    this.models = _.map(models, this.toModel);
    this.length = models.length;
    this.uri = "/api" + options.uri;
  },
  
  fetch: function(options) {
    var self = this;
    $.getJSON(this.uri, options.data, function(data) {
      self.models = _.map(data, function(d) { return self.toModel(d); });
      self.removeDupes();
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
      "events": Event,
      "announcements": Announcement,
      "posts": Post,
      "group_posts": GroupPost,
      "transactions": Transaction
    }[data.schema](data);
    return x;
  },
  
  length: 0,
  
  isEmpty: function() {
    return this.models.length == 0;
  },
  
  setDupes: function(dupes) { this.duplicates = dupes; },

  first: function() { return this.models[0]; },
  
  removeDupes: function() {
    var self = this;
    this.models = _.filter(this.models, function(model) {
      var isDupe = _.any(self.duplicates, function(dupe) {
        return dupe.id == model.id && dupe.get("schema") == model.get("schema");
      });
      return !isDupe;
    });
    this.length = this.models.length;
  }
});
