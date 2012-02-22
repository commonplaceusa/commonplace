
var FeedInboxPage = CommonPlace.View.extend({
  template: "feed_inbox_page/main",
  track: true,
  page_name: "feed_inbox",

  initialize: function() {
    this.collection = new Messages([], { uri: CommonPlace.account.link("feed_messages") });
  },

  afterRender: function() {
    var self = this;
    this.$("#inbox-nav .feed_inbox").addClass("current");
    this.collection.fetch({
      success: function() {
        var listview = new MessageWire({
          collection: self.collection,
          el: self.$("#message-list")
        });
        listview.render();
      }
    });
  },

  bind: function() {
    $("body").addClass("inbox");
    CommonPlace.layout.bind();
  },

  unbind: function() {
    $("body").removeClass("inbox");
    CommonPlace.layout.unbind();
  }

});

