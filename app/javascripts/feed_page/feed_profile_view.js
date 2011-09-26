
var FeedProfileView = CommonPlace.View.extend({
  template: "feed_page/feed-profile",
  id: "feed-profile",
  
  events: {
    "click button.send-message": "openMessageModal"
  },
  
  openMessageModal: function() {
    var formview = new MessageFormView({
      model: new Message({messagable: this.model})
    });
    formview.render();
  },

  avatarSrc: function() { return this.model.get("links").avatar.large; },
  address: function() { return this.model.get("address"); },
  phone: function() { return this.model.get("phone"); },
  website: function() { return this.model.get("website"); }
  
});
