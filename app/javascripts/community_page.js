//= require_tree ./main_page
var CommunityPage = CommonPlace.View.extend({
  template: "main_page.main-page",
  id: "main",

  initialize: function(options) {
    this.account = CommonPlace.account;
    this.community = CommonPlace.community;

    var profileDisplayer = new ProfileDisplayer({});    

    this.postBox = new PostBox({ 
      account: this.account,
      community: this.community
    });

    this.lists = new CommunityResources({
      account: this.account,
      community: this.community,
      showProfile: function(p) { profileDisplayer.show(p); }
    });

    this.profileBox = new ProfileBox({
      profileDisplayer: profileDisplayer
    });

    CommonPlace.profileBox = this.profileBox;

    this.views = [this.postBox, this.lists, this.profileBox];
  },

  afterRender: function() {
    var self = this;
    _(this.views).each(function(view) {
      view.render();
      self.$("#" + view.id).replaceWith(view.el);
    });
  },

  bind: function() { 
    $("body").addClass("community");
    CommonPlace.layout.bind();
  },

  unbind: function() {
    $("body").removeClass("community");
    CommonPlace.layout.unbind();
  }

});


$(function() {
  
  if (Features.isActive("2012Release")) {
    $("body").addClass("fixedLayout");
    CommonPlace.layout = new FixedLayout();
  } else {
    CommonPlace.layout = new StaticLayout();
  }

});

