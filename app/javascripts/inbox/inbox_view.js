
var InboxView = CommonPlace.View.extend({
  template: "inbox/inbox",
  id: "inbox",

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;

    var self = this;
    var messages = new Messages([], { uri: this.account.link('inbox') });

    messages.fetch({
      success: function(collection) {
        var listview = new MessageWire({
          account: self.account,
          community: self.community,
          collection: collection
        });
        listview.render();
        self.$("#message-list").replaceWith(listview.el);
      }
    });
  }
});

