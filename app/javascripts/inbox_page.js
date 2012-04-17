
var InboxPage = CommonPlace.View.extend({
  template: "inbox_page/main",
  track: true,
  page_name: "inbox",

  initialize: function() {
    this.collection = new Messages([], { uri: CommonPlace.account.link("inbox") });
  },

  afterRender: function() {
    var self = this;
    this.$("#inbox-nav .inbox").addClass("current");
    this.collection.fetch({
      success: _.bind(function() {
        this.listview = new MessageWire({
          collection: this.collection,
          el: this.$("#message-list"),
          callback: function() {
            if (window.location.hash) {
              $(window).scrollTop($("#message_" + window.location.hash.substr(1)).position().top);
            }
          }
        });
        this.$("div#message-list.loading").removeClass("loading");
        this.listview.render();
      }, this)
    });
  },

  bind: function() {
    $("body").addClass("inbox");
  },

  unbind: function() {
    $("body").removeClass("inbox");
  }

});

