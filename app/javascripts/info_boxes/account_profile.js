var AccountProfileBox = Profile.extend({
  template: "main_page/profiles/account-profile",
  className: "profile",

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  fullName: function() { return this.model.get("name"); },
  
  shortName: function() { return this.model.get("first_name"); },
  
  about: function() { return this.model.get('about'); },

  interests: function() { return this.model.get('interests'); },

  skills: function() { return ["climbing", "falling"]; },

  subscriptions: function() { return this.model.get('subscriptions'); },
  
  groups: function() { return ""; }
  
});
