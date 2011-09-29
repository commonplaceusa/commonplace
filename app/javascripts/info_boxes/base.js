
var InfoBox = CommonPlace.View.extend({
  id: "info-box",
  template: "main_page/info-box",
  profileId: "#profile",
  listId: "#info-list",
  profileType: "account",
  lastCollection: null,

  afterRender: function() {
    var self = this;
    $(window).scroll(function() {
      self.setPosition();
    });
  },

  setPosition: function() {
    var $el = $(this.el);
    var marginTop = parseInt($el.css("margin-top"), 10);
    var $parent = $el.parent();
    var topScroll = $(window).scrollTop();
    var distanceFromTop = $el.offset().top;
    var parentBottomDistanceToTop = $parent.offset().top + $parent.height();

    if ($el.css("position") == "relative") {
      if (distanceFromTop < topScroll) {
        $el.css({ position: "fixed", top: 0 });
      }
    } else {
      if (distanceFromTop < parentBottomDistanceToTop + marginTop) {
        $el.css({ position: "relative" });
      }
    }
  },

  show: function(type, model) {
    var self = this;
    var accountId = this.options.account.id;
    if (type == "account" && model && model.id) {
      if (accountId != model.id) { type = "users"; }
    }
    if (type == "users" && model) {
      if (accountId == model.id) { type = "account"; }
    }
    this.profileType = type;
    var profile;
    this.showList(this.collectionFor(type), function(collection) {
      if (type == "account" && !model) {
        model = collection.find(function(item) {
          return accountId == item.id;
        });
      }
      if (type == "users" && !model) {
        model = collection.find(function(item) {
          return accountId != item.id;
        });
      }
      profile = self.profileBoxFor(type, ( model ? model : collection.first() ));
      profile.render();
      self.$(self.profileId).replaceWith(profile.el);
      self.setPosition();
      $(self.el).css({ width: $(self.el).width() });
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
    "click .filter-tab": "switchTab"
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
    "click": "switchProfile"
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

  switchProfile: function(e) {
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
