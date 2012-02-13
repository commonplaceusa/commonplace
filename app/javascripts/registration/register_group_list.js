var RegisterGroupListView = CommonPlace.View.extend({
  template: "registration.group",
  
  events: {
    "click input.continue": "submit",
    "submit form": "submit"
  },
  
  initialize: function(options) {
    if (!CommonPlace.account.isAuth()) { options.nextPage("new_user"); }
  },

  afterRender: function() {
    var groups = this.options.communityExterior.grouplikes;
    var $ul = this.$("ul.groups_container");
    
    _.each(groups, _.bind(function(group) {
      var itemView = new this.GroupLikeItem({ model: group });
      itemView.render();
      $ul.append(itemView.el);
    }, this));
    
    this.options.slideIn(this.el);
    
    var height = 0;
    this.$(".groups_container li").each(function(index) {
      if (index == 3) { return false; }
      height = height + $(this).outerHeight(true);
    });
    this.$("ul").height(height + "px");
  },
  
  community_name: function() { return this.options.communityExterior.name; },
  
  submit: function(e) {
    if (e) { e.preventDefault(); }
    
    var groups = _.map(this.$("input[name=groups_list]:checked"), function(group) { return $(group).val(); });
    if (_.isEmpty(groups)) {
      this.finish();
    } else {
      CommonPlace.account.subscribeToGroup(groups, _.bind(function() { this.finish(); }, this));
    }
    
    var feeds = _.map(this.$("input[name=feeds_list]:checked"), function(feed) { return $(feed).val(); });
    if (_.isEmpty(feeds)) {
      this.finish();
    } else {
      CommonPlace.account.subscribeToFeed(feeds, _.bind(function() { this.finish(); }, this));
    }
  },
  
  finish: function() {
    if (this._finished) {
      this.options.nextPage("neighbors");
    } else { this._finished = true; }
  },
  
  GroupLikeItem: CommonPlace.View.extend({
    template: "registration.group-like-item",
    tagName: "li",
    
    events: { "click": "check" },
    
    initialize: function(options) { this.model = options.model; },
    
    avatar_url: function() { return this.model.avatar_url; },
    grouplike_id: function() { return this.model.id; },
    grouplike_name: function() { return this.model.name; },
    about: function() { return this.model.about; },
    
    isGroup: function() { return this.model.schema == "groups"; },
    
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
