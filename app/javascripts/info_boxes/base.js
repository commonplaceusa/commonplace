
var InfoBox = CommonPlace.View.extend({
  id: "info-box",
  template: "main_page/info-box",
  profileId: "#profile",
  listId: "#info-list",
  profileType: "account",
  lastCollection: null,

  show: function(type, model) {
    var self = this;
    this.profileType = type;
    var profile;
    this.showList(this.collectionFor(type), function(collection) {
      profile = self.profileBoxFor(type, ( model ? model : collection.first() ));
      profile.render();
      self.$(self.profileId).replaceWith(profile.el);
    });
    this.$(".filter-tab").removeClass("current");
    this.$("." + type + "-filter").addClass("current");
  },

  showUser: function(user) {
    this.show("users", user);
  },

  showGroup: function(group) {
    this.show("groups", group);
  },

  showFeed: function(feed) {
    this.show("feeds", feed);
  },

  showAccount: function(user) {
    this.show("account", user);
  },

  showList: function(collection, callback) {
    var self = this;
    if (collection == this.lastCollection) {
      if (callback) { callback(collection); }
      return;
    }
    this.lastCollection = collection;
    $(self.listId).empty();
    collection.fetch({
      success: function() {
        collection.each(function(item) {
          var list = new InfoListItem({ model: item, account: self.account });
          list.render();
          $(self.listId).append(list.el);
        });
        if (callback) { callback(collection); }
      }
    });
    var group = {
      "account": "neighbors",
      "users": "neighbors",
      "groups": "community",
      "feeds": "community"
    };
    this.$("h2").text("Learn about your " + group[this.profileType] + ":");
  },

  events: {
    "click .feeds-filter": "switchTab",
    "click .users-filter": "switchTab",
    "click .groups-filter": "switchTab"
  },

  profileBoxFor: function(type, model) {
    return new (this.config(type).profileBox)({ model: model, account: this.options.account });
  },

  collectionFor: function(type) {
    return this.config(type).collection;
  },

  config: function(type) {
    return {
      "account": { profileBox: AccountProfileBox, collection: this.options.community.users },
      "users":  { profileBox: UserProfileBox, collection: this.options.community.users },
      "groups": { profileBox: GroupProfileBox, collection: this.options.community.groups },
      "feeds": { profileBox: FeedProfileBox, collection: this.options.community.feeds } 
    }[type];    
  },

  switchTab: function(e) {
    e.preventDefault();
    var type = $(e.target).attr("href").split("#")[1];
    this.show(type);
  }

});

var InfoListItem = CommonPlace.View.extend({
  template: "main_page/info-list",

  events: {
    "click": "switch"
  },

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

  switch: function(e) {
    e.preventDefault();
    window.infoBox.show(window.infoBox.profileType, this.model);
  }
  
});

var Profile = CommonPlace.View.extend({
  id: "profile",
  
  aroundRender: function(render) {
    this.model.fetch({
      success: render
    });
  }
});
