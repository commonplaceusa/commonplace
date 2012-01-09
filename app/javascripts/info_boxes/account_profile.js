var AccountProfileBox = Profile.extend({
  template: "main_page.profiles.account-profile",
  className: "profile",

  comma: function(item) {
    return " " + item;
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },

  fullName: function() { return this.model.get("name"); },
  
  shortName: function() { return this.model.get("first_name"); },
  
  about: function() { return this.model.get('about'); },

  interests: function() { return _.map(this.model.get('interests'), this.comma); },

  skills: function() { return _.map(this.model.get("skills"), this.comma); },
  
  goods: function() { return _.map(this.model.get("goods"), this.comma); },

  subscriptions: function() { return this.model.get('subscriptions'); },
  
  groups: function() { return ""; },

  hasInterests: function() { return this.model.get("interests").length > 0; },

  hasSkills: function() { return this.model.get("skills").length > 0; },

  hasGoods: function() { return this.model.get("goods").length > 0; },

  hasAbout: function() { return this.model.get("about") != undefined; },
  
  post_count: function() { return this.model.get('post_count'); },

  reply_count: function() { return this.model.get('reply_count'); }
  
});
