
var AccountInfoBox = InfoBox.extend({
  template: "info_boxes/account-info-box",
  className: "account",

  avatarUrl: function() { return this.model.get("avatar_url"); },

  fullName: function() { return this.model.get("name"); },

  about: function() { 
    return this.model.get("about");
  },

  interests: function() { return this.model.get("interests"); },

  offers: function() { return this.model.get("offers"); },

  subscriptions: function() { return this.model.get("subscriptions"); },
  
  groups: function() { return ""; }
  
});