
var MessageWire = Wire.extend({
  template: "inbox/message-list",
  id: "message-list",
  
  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
    this.collection = options.collection;
    this.options.perPage = 5;
    this.itemView = MessageWireItem;
  },

  afterRender: function() {    
    var self = this;
    this.collection.each(function(msg) {
      var messageview = new MessageWireItem({
        account: self.account,
        community: self.community,
        model: msg
      });
      messageview.render();
      self.$(".list").append(messageview.el);
    });
  }
});

