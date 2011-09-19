var UserInfoBox = InfoBox.extend({
  template: "info_boxes/user-info-box",
  className: "user",

  events: {
    "click button.message": "showMessageForm"
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  fullName: function() { return this.model.get("name"); },
  
  shortName: function() { return this.model.get("first_name"); },
  
  about: function() { return this.model.get('about'); },

  interests: function() { return this.model.get('interests'); },

  subscriptions: function() { return this.model.get('subscriptions'); },
  
  groups: function() { return ""; },

  showMessageForm: function() {
    var formView = new MessageFormView({
      model: new Message({ messagable: this.model })
    });
    formView.render();
  }
  
});