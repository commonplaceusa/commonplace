var RegisterGroupListView = CommonPlace.View.extend({
  template: "registration.group",
  
  events: {
    "click a.continue": "submit"
  },

  afterRender: function() {
    this.appendGroupsList(this.options.communityExterior.groups);
  },
  
  community_name: function() { return this.options.communityExterior.name; },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    
    var groups = _.map(this.$("input:checked"), function(group) { return $(group).val(); });
    CommonPlace.account.subscribeToGroup(groups, _.bind(function() {
      this.options.completion();
    }, this));
  },

  appendGroupsList: function(groups) {
    var $ul = this.$("ul.groups_container");
    
    _.each(groups, _.bind(function(group) {
      var itemView = new this.GroupItem({ model: group });
      itemView.render();
      $ul.append(itemView.el);
    }, this));
    
    this.options.slideIn(this.el);
  },
  
  GroupItem: CommonPlace.View.extend({
    template: "registration.group-item",
    tagName: "li",
    
    events: { "click": "check" },
    
    initialize: function(options) { this.model = options.model; },
    
    avatar_url: function() { return this.model.avatar_url; },
    
    group_id: function() { return this.model.id; },
    
    group_name: function() { return this.model.name; },
    
    about: function() { return this.model.about; },
    
    check: function(e) {
      if (e) { e.preventDefault(); }
      var $checkbox = this.$("input[type=checkbox]");
      if ($checkbox.attr("checked")) {
        $checkbox.removeAttr("checked");
      } else {
        $checkbox.attr("checked", "checked");
      }
    }
  })
});
