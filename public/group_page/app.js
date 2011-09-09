var GroupPageRouter = Backbone.Controller.extend({

  routes: {},

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
    this.group = options.group;
    this.groupsList = new GroupsListView({ collection: options.groups, el: $("#groups-list") });
    this.groupsList.render();
    this.show(options.group);
  },

  show: function(slug) {
    var self = this; 
    $.getJSON("/api" + this.community.links.groups, function(groups) {
      self.groupsList.select(slug);
      $.getJSON("/api/groups/" + slug, function(response) {
        var group = new Group(response);
        
        document.title = group.get('name');
        
        var groupView = new GroupView({ model: group, community: self.community, account: self.account });
        window.currentGroupView = groupView;
        groupView.render();
        
        $("#group").replaceWith(groupView.el);
      });
    });
  }

});

var GroupView = CommonPlace.View.extend({
  template: "group_page/group",
  id: "group",

  initialize: function(options) {
    var self = this;
    this.community = options.community;
    this.account = options.account;
    var group = this.model;
    var profile, header, newpost, nav, subresources, list;

    profile = new GroupProfileView({model: group});
    header = new GroupHeaderView({model: group});
    newpost = new NewPostView({model: group});
    nav = new GroupNavView({model: group});
    subresources = new GroupSubresourcesView({model: group});
    list = new GroupsListView({model: group});

    //nav.bind("switchTab", function(tab) { subresources.switchTab(tab); });

    this.subviews = [profile, header, newpost, nav, subresources, list];

  },
  
  afterRender: function() {
    var self = this;
    _(this.subviews).each(function(view) {
      view.render();
      self.$("#" + view.id).replaceWith(view.el);
    });
  }

});

var GroupHeaderView = CommonPlace.View.extend({
  template: "group_page/header",
  id: "group-header",
  
  initialize: function(options) { this.account = options.account },

  name: function() {
    return this.model.get("name");
  }
});

var GroupProfileView = CommonPlace.View.extend({
  template: "group_page/profile",
  id: "group-profile",
  
  avatar_url: function() {
    return this.model.get("avatar_url");
  },

  about: function() {
    return this.model.get("about");
  }
});

var NewPostView = CommonPlace.View.extend({
  template: "group_page/new-post",
  id: "new-post"
});

var GroupsListView = CommonPlace.View.extend({
  template: "group_page/groups-list",

  groups: function() {
    return this.collection;
  },

  select: function(slug) {
    this.$("li").removeClass("current");
    this.$("li[data-group-slug=" + slug + "]").addClass("current");
  }

});

var GroupNavView = CommonPlace.View.extend({
  template: "group_page/nav",
  id: "group-nav",

  events: {
    "click a": "navigate"
  },

  initialize: function(options) {
    this.current = options.current || "showPosts";
  },
  
  navigate: function(e) {
    e.preventDefault();
    this.current = $(e.target).attr('data-tab');
    this.trigger('switchTab', this.current);
    this.render();
  },

  classIfCurrent: function() {
    var self = this;
    return function(text) {
      return this.current == text ? "current" : "";
    };
  }
  
});

var GroupSubresourcesView = CommonPlace.View.extend({
  template: "group_page/subresources",
  id: "group-subresources",
  
  initialize: function(options) {
    this.account = options.account;
    this.group = options.model;
    this.groupPostsCollection = this.group.posts;
    this.groupMembersCollection = this.group.members;
    this.currentTab = options.current || "showGroupPosts";
    //this.group.posts.bind("add", function() { this.switchTab("showGroupPosts"); }, this);
    //this.group.members.bind("add", function() { this.switchTab("showGroupMembers"); }, this);
  },

  afterRender: function() {
    this[this.currentTab]();
  },

  showGroupPosts: function() {
    var wireView = new GroupPostWireView({
      collection: this.groupPostsCollection,
      account: this.account,
      el: this.$(".group-posts .wire")
    });
    wireView.render();
  },

  showGroupMembers: function() {
    var wireView = new GroupMembersWireView({
      collection: this.groupMembersCollection,
      account: this.account,
      el: this.$(".group-members .wire")
    });
    wireView.render();
  },

  tabs: function() {
    return {
      showGroupPosts: this.$(".group-posts"),
      showGroupMembers: this.$(".group-members")
    };
  },

  classIfCurrent: function() {
    var self = this;
    return function(text) {
      return text == self.currentTab ? "current" : "";
    };
  },

  switchTab: function() {
    this.tabs()[this.currentTab].hide();
    this.currentTab = newTab;
    this.tabs()[this.currentTab].show();
    this.render();
  }

});

