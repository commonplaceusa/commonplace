var GroupProfileBox = Profile.extend({
  template: "main_page/profiles/group-profile",
  className: "profile",

  events: {
    "click button.message": "showMessageForm"
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  fullName: function() { return this.model.get("name"); },
  
  about: function() { return this.model.get('about'); },

  showMessageForm: function() {
    var formView = new MessageFormView({
      model: new Message({ messagable: this.model })
    });
    formView.render();
  }
  
});
