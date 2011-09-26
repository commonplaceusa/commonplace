var AccountProfileBox = Profile.extend({
  template: "main_page/profiles/account-profile",
  className: "profile",

  comma: function(item) {
    return " " + item;
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  fullName: function() { return this.model.get("name"); },
  
  shortName: function() { return this.model.get("first_name"); },
  
  about: function() { return this.model.get('about'); },

  interests: function() { return _.map(this.model.get('interests'), this.comma); },

  skills: function() { return ["climbing", " falling"]; },

  offers: function() { return _.map(this.model.get("offers"), this.comma); },

  subscriptions: function() { return this.model.get('subscriptions'); },
  
  groups: function() { return ""; },

  hasInterests: function() { return this.model.get("interests").length > 0; },
 
  hasSkills: function() { return true; },

  hasOffers: function() { return this.model.get("offers").length > 0; },

  hasAbout: function() { return this.model.get("about") != undefined; }
  
});
