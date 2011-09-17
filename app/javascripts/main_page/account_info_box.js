
var AccountInfoBox = CommonPlace.View.extend({
  template: "main_page/account-info-box",
  id: "info-box",
  className: "account",

  initialize: function(options) {
    this.account = options.account
  },

  fullName: function() { return "John Jacobson" },

  about: function() { 
    return "Lorem ipsum dolor sit amet, consectetuir adipiscing elit." 
  },

  interests: function() { return "1,2,3,4"; },

  offers: function() { return "a,b,c,d"; },

  subscriptions: function() { return "rei, ichi, ni, san, yan"; },
  
  groups: function() { return "hana, dul, set, net, tas, yas, ilgo"; }
  
});