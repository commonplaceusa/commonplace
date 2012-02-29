var FacebookNag = CommonPlace.View.extend({

  template: "shared.facebook-nag",

  events: {
    "click a.cancel": function(e) {
      e.preventDefault();
      CommonPlace.account.set_metadata("completed_facebook_nag", true);
      this.$el.hide();
      CommonPlace.layout.reset();
    },
    "click a.connect": function(e) {
      e.preventDefault();
      facebook_connect_post_registration()
      this.$el.hide();
      CommonPlace.layout.reset();
    }
  }

});
