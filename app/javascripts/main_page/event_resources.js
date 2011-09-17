var EventResources = CommonPlace.View.extend({
  template: "main_page/event-resources",
  className: "resources",

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
  },

  afterRender: function() { 
    var wire = new EventWireView({ collection: this.community.events,
                                  account: this.account,
                                  el: this.$(".events.wire"),
                                  perPage: 15 });
    wire.render();
  }
});
