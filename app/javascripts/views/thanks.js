var ThanksView = CommonPlace.View.extend({
  className: "replies",
  template: "shared.thanks",
  initialize: function(options) {
    // stuff
  },
  
  users: function() { return this.model.get("thanks"); },
  
  author_name: function() { return this.model.get("author"); }
});
