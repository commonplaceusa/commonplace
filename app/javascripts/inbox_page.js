
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
          el: this.$("#message-list")
        });
        this.listview.render();
      }, this)
    });
  },

  bind: function() {
    $("body").addClass("inbox");
  },

  unbind: function() {
    $("body").removeClass("inbox");
    CommonPlace.layout.unbind();
  }

});

