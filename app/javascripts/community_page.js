//= require_tree ./main_page
var CommunityPage = CommonPlace.View.extend({
  template: "main_page.main-page",
  id: "main",
  track: true,
  page_name: "community",

  initialize: function(options) {
    var self = this;
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
      showProfile: function(p) { profileDisplayer.show(p, { from_wire: true }); }
    });

    this.profileBox = new ProfileBox({
      profileDisplayer: profileDisplayer
    });

    profileDisplayer.highlightSingleUser = function(user) {
      self.lists.highlightSingleUser(user);
    }

    this.views = [this.postBox, this.lists, this.profileBox];
  },

  afterRender: function() {
    var self = this;
    _(this.views).each(function(view) {
      view.render();
      self.$("#" + view.id).replaceWith(view.el);
    });
    CommonPlace.layout.reset();
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

