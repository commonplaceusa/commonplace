var ShareView = CommonPlace.View.extend({
  className: "share",
  template: "shared/share",
  initialize: function(options) {
    var self = this;
    this.account = options.account;
  },
  
  afterRender: function() {
  }, 
});
