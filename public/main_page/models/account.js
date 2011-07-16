

CommonPlace.Account = Backbone.Model.extend({
  url: "/api/account",

  can_delete: function(model) {
    return this.get('is_admin')  || this.can_delete_post(model);
  },

  can_delete_post: function(post) {
    return ($.inArray(post.id, this.get('posts')) > -1);
  },

  can_edit_post: function(post) {
    return this.get('is_admin') || ($.inArray(post.id, this.get('posts')) > -1);
  },

  can_notify_all: function(post) {
    return this.get('is_admin') ;
  },

  subscribeToFeed: function(id) {
    var self = this;
    $.post("/api/account/subscriptions/feeds", {id: id}, function() {self.fetch();});
  },
  
  unsubscribeFromFeed: function(id) {
    var self = this;
    $.del("/api/account/subscriptions/feeds/" + id, function() {self.fetch();});
  },

  subscribeToGroup: function(id) {
    var self = this;
    $.post("/api/account/subscriptions/groups", {id: id}, function(){ self.fetch(); });
  },

  unsubscribeFromGroup: function(id) {
    var self = this;
    $.del("/api/account/subscriptions/groups/" + id, function() {self.fetch();});
  }

});
