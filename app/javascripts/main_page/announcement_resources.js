var AnnouncementResources = CommonPlace.View.extend({
  template: "main_page/announcement-resources",
  className: "resources",
  

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
  },

  afterRender: function() { 
    var wire = new AnnouncementWireView({ 
      collection: this.community.announcements,
      account: this.account,
      el: this.$(".announcements.wire"),
      perPage: 15 
    });
    wire.render();
  }
});
