var ProfileDisplayer = Backbone.View.extend({
  id: "profile-box-profile",

  initialize: function() {
    this.current_profile_model = CommonPlace.account;
  },

  render: function() {
    var profile = this.toProfile(this.current_profile_model);
    profile.render();
    $(this.el).empty().append(profile.el);
  },
  
  show: function(profile_model, options) {
    var self = this;
    profile_model.fetch({
      success: function() {
        if (profile_model.get('schema') === "users" &&
            profile_model.id === CommonPlace.account.id) {
          profile_model = CommonPlace.account;
        }

        if (self.current_profile_model.get('schema') !==
            profile_model.get('schema') ||
            self.current_profile_model.id !==
            profile_model.id) {
          self.current_profile_model = profile_model;
          self.render();

          if (options && options.highlight) {
            self.highlight(options.highlight);
          }
        }
      }
    });
  },

  highlight: function(text) {
    $(this.el).highlight(text);
  },

  toProfile: function(profilable) {
    return new ({
      users: UserProfile,
      account: AccountProfile,
      feeds: FeedProfile,
      groups: GroupProfile,
      failed_search: FailedSearch
    }[profilable.get('schema')])({ model: profilable });
  }
  
});
