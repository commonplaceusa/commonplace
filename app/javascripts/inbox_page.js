
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

