CommonPlace.render = function(name, params) {
  return Mustache.to_html(
    CommonPlace.templates[name], 
    params,
    CommonPlace.templates
  );
};


var GroupPageRouter = Backbone.Controller.extend({

  routes: { 
    "/groups/:slug": "show"
  },

  initialize: function(options) {
    this.account = options.account;
  },

  show: function(slug) {
    var self = this;
    $.getJSON("/api/groups/" + slug, function(group) {
      new GroupProfileView({ model: group, el: $("#group-profile")}).render();
      
      new GroupHeaderView({ model: group, account: self.account, el: $("#group-header") }).render();
      
      new NewPostView({ el: $("#new-post") }).render();
      
      new GroupNavView({ model: group, el: $("#group-nav") }).render();

      new GroupPostListView({ el: $("#post-list") }).render();

      $.getJSON("/api/communities/1/groups", function(groups) {
        new GroupsListView({ model: group, collection: groups, el: $("#groups-list"), community: "Nihlists" }).render();
      });
    });
  }
});

var GroupHeaderView = Backbone.View.extend({
  initialize: function(options) { this.account = options.account },

  render: function() {
    $(this.el).html(CommonPlace.render("header", this.model));
    return this;
  }
});

var GroupProfileView = Backbone.View.extend({
  render: function() {
    $(this.el).html(CommonPlace.render("profile", this.model));
    return this;
  }
});

var NewPostView = Backbone.View.extend({
  render: function() {
    $(this.el).html(CommonPlace.render("new-post", {}));
    return this;
  }
});

var GroupsListView = Backbone.View.extend({

  initialize: function(options) {
    this.community = options.community;
  },

  render: function() {
    var self = this;
    $(this.el).html(CommonPlace.render("groups-list", this));

    return this;
  },

  groups: function() {
    var self = this;
    return _(this.collection).map(function(group) {
      return _(group).extend({ isCurrent: group['id'] == self.model['id'] });
    });
  }
});

var GroupNavView = Backbone.View.extend({
  render: function() {
    $(this.el).html(CommonPlace.render("nav", { 
      postsUrl: this.postsUrl(),
      membersUrl: this.membersUrl(),
      postsClass: this.isCurrentUrl(this.postsUrl()) ? "current" : "",
      membersClass: this.isCurrentUrl(this.membersUrl()) ? "current" : ""
    }));
    return this;
  },

  postsUrl: function() { return "/groups/" + this.model['id']  },
  membersUrl: function() { return "/groups/" + this.model['id'] + "/members" },
  isCurrentUrl: function(string) { return window.location.hash.slice(1) == string }
  
});

var GroupPostListView = Backbone.View.extend({

  render: function() {
    $(this.el).html(CommonPlace.render("post-list", {}));
    return this;
  }
});


$(function() {
  $.getJSON("/api/account", function(account) {

    new GroupPageRouter({ account: account });
    window.location.hash = window.location.pathname;
    Backbone.history.start();

  });
});
