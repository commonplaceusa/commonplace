

CommonPlace.Account = Backbone.Model.extend({
  url: "/api/account",

  can_delete: function(model) {
    //return this.get('is_admin')  || this.can_edit(model);
    console.log("Depreciated method");
    return true;
  },

  can_edit_post: function(post) {
    return this.get('is_admin') || ($.inArray(post.id, this.get('posts')) > -1);
  },

  can_edit_event: function(event) {
    return this.get('is_admin') || ($.inArray(event.id, this.get('events')) > -1);
  },

  can_edit_announcement: function(announcement) {
    return this.get('is_admin') || ($.inArray(announcement.id, this.get('announcements')) > -1);
  },

  can_edit_group_post: function(group_post) {
    return this.get('is_admin') || ($.inArray(group_post.id, this.get('group_posts')) > -1);
  },

  can_delete_post : function(post) { return this.can_edit_post(post); },
  can_delete_event : function(event) { return this.can_edit_event(event); },
  can_delete_announcement : function(announcement) { return this.can_edit_announcement(announcement); },
  can_delete_group_post : function(group_post) { return this.can_edit_group_post(group_post); },

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
