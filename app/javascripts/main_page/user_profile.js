var UserProfile = CommonPlace.View.extend({
  template: "main_page.user-profile",
  className: "profile",

  events: {
    "click .message": "showMessageForm",
    "click .meet": "meet",
    "click .unmeet": "unmeet",
    "click ul.history a": "showHistoricalItem"
  },

  comma: function(item) {
    return " " + item;
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  fullName: function() { return this.model.get("name"); },
  
  shortName: function() { return this.model.get("first_name"); },
  
  about: function() { return this.model.get('about'); },

  hasHistory: function() { return this.model.get("history").length > 0; },

  post_count: function() { return this.model.get('post_count'); },

  reply_count: function() { return this.model.get('reply_count'); },

  interests: function() { return _.map(this.model.get('interests'), this.comma); },

  skills: function() { return _.map(this.model.get("skills"), this.comma); },

  goods: function() { return _.map(this.model.get("goods"), this.comma); },

  history: function() { 
    var self = this;
    return _.map(this.model.get('history'), function(h) {
      return new ProfileHistoryItem({ model: h, name: self.shortName() });
    }); 
  },

  subscriptions: function() { return this.model.get('subscriptions'); },
  
  groups: function() { return ""; },

  hasAbout: function() { return this.model.get("about") ; },

  hasInterests: function() { return this.model.get("interests").length > 0; },

  hasSkills: function() { return this.model.get("skills").length > 0; },

  hasGoods: function() { return this.model.get("goods").length > 0; },

  showMessageForm: function(e) {
    e.preventDefault();
    var formView = new MessageFormView({
      model: new Message({ messagable: this.model })
    });
    formView.render();
  },

  meet: function(e) {
    e.preventDefault();
    CommonPlace.account.meetUser(this.model);
    this.$(".just-met").show();
    this.$(".meet").hide();
  },

  unmeet: function(e) {
    e.preventDefault();
    CommonPlace.account.unmeetUser(this.model, _.bind(function() {
      this.render();
    }, this));
  },

  hasMet: function() { return CommonPlace.account.hasMetUser(this.model); },
  
  showHistoricalItem: function() {
    this.options.highlightSingleUser(this.model);
  }
  
});
