
var InboxView = CommonPlace.View.extend({
  template: "inbox/inbox",
  id: "inbox",

  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
    this.type = options.type;

    var self = this;
    this.type = { sent: "sent", received: "inbox", feeds: "feed_messages" }[this.type];
    var uri = this.account.link(this.type);
    var messages = new Messages([], { uri: uri });

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
  },

  title: function() {
    return (this.type == "sent" ? "Your Sent Messages" : "Your Inbox");
  }
});

