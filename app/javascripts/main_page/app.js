
var MainPageRouter = Backbone.Router.extend({

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
    
    this.view = new MainPageView({
      account: this.account,
      community: this.community
    });
    
    this.view.render();

    $("#main").replaceWith(this.view.el);
  },

  routes: {
    "foo": "landing"
  }
  
});


var MainPageView = CommonPlace.View.extend({
  template: "main_page/main-page",
  id: "main",

  initialize: function(options) {
    this.account = this.options.account;
    this.community = this.options.community;
    
    var postBox = new PostBox({ 
      account: this.account,
      community: this.community
    });
    
    var infoBox = new AccountInfoBox({
      account: this.account
    });

    var communityResources = new CommunityResources({
      account: this.account,
      community: this.community
    });
    
    this.views = [postBox, infoBox, communityResources];
  },

  afterRender: function() {
    var self = this;
    _(this.views).each(function(view) {
      view.render();
      self.$("#" + view.id).replaceWith(view.el);
    });
  }
  
});

