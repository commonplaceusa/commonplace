var FeedProfileBox = Profile.extend({
  template: "main_page/profiles/feed-profile",
  className: "profile",

  events: {
    "click .message": "showMessageForm"
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  fullName: function() { return this.model.get("name"); },
  
  shortName: function() { return this.model.get("first_name"); },
  
  about: function() { return this.model.get('about'); },
  
  groups: function() { return ""; },

  showMessageForm: function(e) {
    e.preventDefault();
    var formView = new MessageFormView({
      model: new Message({ messagable: this.model })
    });
    formView.render();
  }
  
});
