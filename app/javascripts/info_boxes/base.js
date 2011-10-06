var InfoListItem = CommonPlace.View.extend({
  template: "main_page/info-list",
  tagName: "li",
  events: {
    "click a": "switchProfile"
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
    $(this.el).siblings().removeClass("current");
    $(this.el).addClass("current");
    e.preventDefault();
    window.infoBox.showProfile(this.model);
  }
  
});

var InfoBox = CommonPlace.View.extend({
  id: "info-box",
  template: "main_page/info-box",
  $profile: function() { return this.$("#profile"); },
  $list: function() { return this.$("#info-list"); },

  events: {
    "click .filter-tab": "switchTab",
    "keyup .search": "filterBySearch"
  },

  afterRender: function() {
    var self = this;
    this.showProfile(this.options.account);
    $(window).scroll(function() {
      $(self.el).css({ width: $(self.el).width() });
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

  showProfile: function(model) {
    var self = this;
    model.fetch({ 
      success: function() {
        if (model.get('schema') == "user" && model.id == self.options.account.id) {
          model = self.options.account;
        }

        var profile = self.profileBoxFor(model);
        var collection = self.collectionFor(model);
        
        self.showCollection(collection, false);
      
        profile.render();
        
        self.$profile().replaceWith(profile.el);
        
        self.$(".filter-tab").removeClass("current");
        self.$("." + model.get('schema') + "-filter").addClass("current");

        self.$("h2").text(self.t(model.get('schema') + ".h2"));
      }
    });
  },

  showCollection: function(collection, showFirst) {
    if (this.currentCollection == collection && !showFirst) { return ; }

    this.currentCollection = collection;

    var self = this;

    collection.fetch({ 
      success: function() {
        console.log(collection);
        if (collection.length == 0) { return; }
        self.$list().empty();
        collection.each(function(model) {
          var item = new InfoListItem({ 
            model: model, 
            account: self.options.account
          });
          item.render();
          self.$list().append(item.el);
        });
        
        if (showFirst) {
          self.showProfile(collection.first());
        }
      }
    });                
  },

  showSearch: function(query) {
    var self = this;
    this.currentCollection.search(query);
    this.showCollection(this.currentCollection, true);
  },

  profileBoxFor: function(model) {
    return new (this.config(model.get('schema')).profileBox)({ 
      model: model, account: 
      this.options.account 
    });
  },

  collectionFor: function(model) {
    return this.config(model.get('schema')).collection;
  },

  config: function(type) {
    return {
      "account": { profileBox: AccountProfileBox, 
                   collection: this.options.community.users
                 },
      "user":  { profileBox: UserProfileBox, 
                 collection: this.options.community.users
               },
      "group": { profileBox: GroupProfileBox, 
                 collection: this.options.community.groups
               },
      "feed": { profileBox: FeedProfileBox, 
                collection: this.options.community.feeds
              } 
    }[type];    
  },

  switchTab: function(e) {
    e.preventDefault();
    var type = $(e.target).attr("href").split("#")[1];
    if (type == "account") {
      this.showProfile(this.options.account);
    } else {
      this.showCollection(this.options.community[type], true);
    }
  },

  filterBySearch: function(e) {
    e.preventDefault();
    query = this.$("form > input").val();
    this.showSearch(query);
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
