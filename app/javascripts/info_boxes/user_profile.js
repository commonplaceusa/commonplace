var UserProfileBox = Profile.extend({
  template: "main_page/profiles/user-profile",
  className: "profile",

  events: {
    "click .message": "showMessageForm",
    "click .meet": "meet",
    "click .unmeet": "unmeet"
  },

  comma: function(item) {
    return " " + item;
  },

  avatarUrl: function() { return this.model.get('avatar_url'); },
  
  fullName: function() { return this.model.get("name"); },
  
  shortName: function() { return this.model.get("first_name"); },
  
  about: function() { return this.model.get('about'); },

  interests: function() { return _.map(this.model.get('interests'), this.comma); },

  skills: function() { return _.map(this.model.get("offers"), this.comma); },

  subscriptions: function() { return this.model.get('subscriptions'); },
  
  groups: function() { return ""; },

  hasAbout: function() { return this.model.get("about") != undefined; },

  hasInterests: function() { return this.model.get("interests").length > 0; },

  hasSkills: function() { return this.model.get("offers").length > 0; },

  showMessageForm: function(e) {
    e.preventDefault();
    var formView = new MessageFormView({
      model: new Message({ messagable: this.model })
    });
    formView.render();
  },

  meet: function(e) {
    e.preventDefault();
    this.options.account.meetUser(this.model);
    this.render();
  },

  unmeet: function(e) {
    e.preventDefault();
    this.options.account.unmeetUser(this.model);
    this.render();
  },

  hasMet: function() { return this.options.account.hasMetUser(this.model); }
  
});
