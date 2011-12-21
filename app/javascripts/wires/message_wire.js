
var MessageWire = Wire.extend({
  template: "inbox/message-list",
  id: "message-list",
  
  initialize: function(options) {
    this.collection = options.collection;
    this.options.perPage = 5;
    this.itemView = MessageWireItem;
  },

  afterRender: function() {    
    var self = this;
    this.collection.each(function(msg) {
      var messageview = new MessageWireItem({
        account: CommonPlace.account,
        community: CommonPlace.community,
        model: msg
      });
      messageview.render();
      self.$(".list").append(messageview.el);
    });
  }
});

