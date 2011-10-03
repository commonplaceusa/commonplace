var GroupProfileView = CommonPlace.View.extend({
  template: "group_page/profile",
  id: "group-profile",
  
  avatar_url: function() {
    return this.model.get("avatar_url");
  },

  about: function() {
    return this.model.get("about");
  }
});
