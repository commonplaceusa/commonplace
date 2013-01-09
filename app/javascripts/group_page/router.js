var GroupPageRouter = Backbone.Router.extend({

  routes: {},

  initialize: function(options) {
    var header = new CommonPlace.shared.HeaderView({ el: $("#header") });
    header.render();

    this.account = new Account(options.account);
    this.community = options.community;
    this.group = options.group;
    this.groupsList = new GroupsListView({
      collection: options.groups,
      el: $("#groups-list"),
      community: this.community
    });
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
