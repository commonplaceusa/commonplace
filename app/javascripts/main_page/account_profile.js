var AccountProfile = CommonPlace.View.extend({
  template: "main_page.account-profile",
  className: "profile",

  comma: function(item) {
    return " " + item;
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },

  fullName: function() { return this.model.get("name"); },
  
  shortName: function() { return this.model.get("short_name"); },
  
  about: function() { return this.model.get('about'); },

  interests: function() { return _.map(this.model.get('interests'), this.comma); },

  skills: function() { return _.map(this.model.get("skills"), this.comma); },
  
  goods: function() { return _.map(this.model.get("goods"), this.comma); },

  subscriptions: function() { return this.model.get('subscriptions'); },

  history: function() { 
    var self = this;
    return _.map(this.model.get('history'), function(h) { 
      return new ProfileHistoryItem({ model: h, name: self.shortName() }) 
    }); 
  },
  
  groups: function() { return ""; },

  hasInterests: function() { return this.model.get("interests").length > 0; },

  hasSkills: function() { return this.model.get("skills").length > 0; },

  hasGoods: function() { return this.model.get("goods").length > 0; },

  hasAbout: function() { return this.model.get("about") !== undefined; },

  hasHistory: function() { return this.model.get("history").length > 0; },
  
  post_count: function() { return this.model.get('post_count'); },

  reply_count: function() { return this.model.get('reply_count'); },
  
  editUrl: function() {
    return "/" + CommonPlace.community.get("slug") + "/account";
  }
  
});
