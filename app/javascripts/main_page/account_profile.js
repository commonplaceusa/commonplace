var AccountProfile = CommonPlace.View.extend({
  template: "main_page.account-profile",
  className: "profile",
  
  events: {
    "click ul.history a": "showHistoricalItem"
  },

  comma: function(item) {
    return " " + item;
  },

  afterRender: function() {
    var self = this;
    this.model.profileHistory(function(history_items) {
      var view = new ProfileHistory({ 
        collection: history_items, 
        el: self.$(".profile-history"),
        model: self.model
      });
      view.render();
    });
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },

  fullName: function() { return this.model.get("name"); },
  
  shortName: function() { return this.model.get("short_name"); },
  
  about: function() { return this.model.get('about'); },

  interests: function() { return _.map(this.model.get('interests'), this.comma); },

  skills: function() { return _.map(this.model.get("skills"), this.comma); },
  
  goods: function() { return _.map(this.model.get("goods"), this.comma); },

  subscriptions: function() { return this.model.get('subscriptions'); },

  
  groups: function() { return ""; },

  hasInterests: function() { return this.model.get("interests").length > 0; },

  hasSkills: function() { return this.model.get("skills").length > 0; },

  hasGoods: function() { return this.model.get("goods").length > 0; },

  hasAbout: function() { return this.model.get("about") !== undefined; },

  
  post_count: function() { return this.model.get('post_count'); },

  reply_count: function() { return this.model.get('reply_count'); },
  
  editUrl: function() {
    return "/" + CommonPlace.community.get("slug") + "/account";
  },
  
  showHistoricalItem: function() {
    this.options.highlightSingleUser(this.model);
  }
  
});
