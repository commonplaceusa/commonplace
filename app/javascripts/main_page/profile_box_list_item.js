var ProfileBoxListItem = CommonPlace.View.extend({

  template: "main_page.profile-box-list-item",
  tagName: "li",

  avatarUrl: function() { return this.model.get('avatar_url'); },

  title: function() { return this.model.get("name"); },
  
  about: function() {
    var longText = this.model.get("about");
    if (longText) {
      var shortText = longText.match(/\b([\w]+[\W]+){6}/);
      return (shortText) ? shortText[0] : longText;
    }
    return "";
  },

  events: {
    "click": "switchProfile",
    "click a": "switchProfile"
  },

  switchProfile: function(e) {
    e.preventDefault();
    this.options.showProfile(this.model);
  }
});
