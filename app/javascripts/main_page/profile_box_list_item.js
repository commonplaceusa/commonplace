var ProfileBoxListItem = CommonPlace.View.extend({

  template: "main_page.profile-box-list-item",
  tagName: "li",
  
  avatarUrl: function() { return this.model.get('avatar_url'); },

  title: function() { return this.model.get("name"); },
  
  wireUrl: function() {
    if (this.model.get("schema") == "users") {
      return "/" + CommonPlace.community.get("slug") +
             "/show/users/" + this.model.id;
    } else { return "#"; }
  },
  
  about: function() {
    var longText = this.model.get("about");
    if (longText) {
      var shortText = longText.match(/\b([\w]+[\W]+){6}/);
      return (shortText) ? shortText[0] : longText;
    }
    return "";
  },

  events: {
    "click": "clickLI",
    "click a": "clickA"
  },
  
  clickLI: function(e) {
    if (e) {
      e.preventDefault();
      if (e.target.tagName != "A") { this.$("a").first().click(); }
    }
  },
  
  clickA: function(e) {
    if (e && this.model.get("schema") != "users") { e.preventDefault(); }
  }
});
