
var AccountRouter = Backbone.Router.extend({
  routes: {
    "": "show"
  },
  
  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
    this.interests = options.interests;
    this.skills = options.skills;
    this.goods = options.goods;
  },
  
  show: function() {
    var editview = new AccountEditView({
      account: this.account,
      community: this.community,
      interests: this.interests,
      skills: this.skills,
      goods: this.goods
    });
    editview.render();
    $("#account-edit").replaceWith(editview.el);
    editview.$("select.list").chosen();
  }
});

