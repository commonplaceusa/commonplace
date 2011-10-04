
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
  website: function() { 
    if (!this.model.get("website")) { return false; }

    if (this.model.get("website").length <= 35) {
      return this.model.get("website"); 
    } else {
      return this.model.get("website").substring(0,32) + "...";
    }
  },
  
  websiteURL: function() { return this.model.get("website"); }
  
});
