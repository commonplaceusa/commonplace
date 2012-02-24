var RegisterGroupListView = RegistrationModalPage.extend({
  template: "registration.group",
  
  events: {
    "click input.continue": "submit",
    "submit form": "submit"
  },

  afterRender: function() {
    var groups = this.communityExterior.groups;
    var $ul = this.$("ul.groups_container");
    
    _.each(groups, _.bind(function(group) {
      var itemView = new this.GroupItem({ model: group });
      itemView.render();
      $ul.append(itemView.el);
    }, this));
    
    this.slideIn(this.el);
    
    var height = 0;
    this.$(".groups_container li").each(function(index) {
      if (index == 3) { return false; }
      height = height + $(this).outerHeight(true);
    });
    this.$("ul").height(height + "px");
  },
  
  community_name: function() { return this.communityExterior.name; },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    
    var groups = _.map(this.$("input[name=groups_list]:checked"), function(group) { return $(group).val(); });
    if (_.isEmpty(groups)) {
      this.finish();
    } else {
      CommonPlace.account.subscribeToGroup(groups, _.bind(function() { this.finish(); }, this));
    }
  },
  
  finish: function() {
    if (this.communityExterior.has_residents_list) {
      this.nextPage("neighbors", this.data);
    } else {
      this.complete();
    }
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
        this.$(".check").removeClass("checked");
      } else {
        $checkbox.attr("checked", "checked");
        this.$(".check").addClass("checked");
      }
    }
  })
});
