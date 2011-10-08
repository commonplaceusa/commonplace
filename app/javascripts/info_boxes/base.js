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
    window.infoBox.showList(this.model.get("schema"), this.model);
  }
  
});

var InfoBox = CommonPlace.View.extend({
  id: "info-box",
  template: "main_page/info-box",
  $profile: function() { return this.$("#profile"); },
  $list: function() { return this.$("#info-list"); },

  events: {
    "click .filter-tab": "switchTab",
    "click .remove-search": "removeSearch",
    "change .search": "filterBySearch",
    "submit form": "filterBySearch",
    "keyup .search": "filterBySearch"
  },

  afterRender: function() {
    var self = this;
    this.currentCollection = {};
    this.currentQuery = "";
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

  isAccount: function(model) {
    if (model.get("id") != this.options.account.id) {
      return false;
    } else {
      return model.get("schema") == "user" || model.get("schema") == "account";
    }
  },

  showProfile: function(model) {
    var self = this;

    this.$(".remove-search").hide();
    this.currentQuery = "";

    model.fetch({
      success: function() {
        if (self.isAccount(model)) { model = self.options.account; }

        self.renderProfile(model);

        self.currentQuery = "";
        self.$("form > input").val(self.currentQuery);

        self.currentCollection = self.collectionFor(model);
        self.currentCollection.fetch({
          success: function() {
            self.renderList(self.currentCollection);
          }
        });
      }
    });
  },

  showList: function(schema, model) {
    var self = this;

    var partial = this.currentQuery ? this.options.community.search : this.options.community;
    var collection = (schema == "account") ? partial.users : partial[schema];

    if (schema == "account") {
      if ( (model && this.isAccount(model)) || !model) {
        model = this.options.account;
      }
    }

    collection.fetch({
      data: { query: this.currentQuery },
      success: function() {
        if (collection.length == 0) {
          self.$(".remove-search").removeClass("not-empty");
          self.$(".remove-search").addClass("empty");
          collection = self.options.community;
          collection = (schema == "account") ? collection.users : collection[schema];
          collection.fetch({
            success: function() {
              self.showFetchedList(collection, model);
            }
          });
        } else {
          this.$(".remove-search").addClass("not-empty");
          this.$(".remove-search").removeClass("empty");
          self.showFetchedList(collection, model);
        }
      }
    });
  },

  showFetchedList: function(collection, model) {
    if (collection != this.currentCollection) {
      this.renderList(collection);
      this.currentCollection = collection;
    }

    var firstIsAccount = this.isAccount(collection.first());
    var self = this;

    if ((firstIsAccount && collection.length == 1)) {
      model = this.options.account;
    } else {
      if (model) {
        model = this.isAccount(model) ? this.options.account : model;
      } else {
        model = firstIsAccount ? collection.at(1) : collection.first();
      }
    }
    model.fetch({
      success: function() {
        self.renderProfile(model);
      }
    });
  },

  renderProfile: function(model) {
    var profile = this.profileBoxFor(model);
    profile.render();
    this.$profile().replaceWith(profile.el);
    this.changeSchema(model.get("schema"));
  },

  renderList: function(collection) {
    var self = this;
    this.$list().empty();
    collection.each(function (model) {
      var item = new InfoListItem({
        model: model,
        account: self.options.account
      });
      item.render();
      self.$list().append(item.el);
    });
  },

  changeSchema: function(schema) {
    this.$(".filter-tab").removeClass("current");
    this.$("." + schema + "-filter").addClass("current");
    this.$("h2").text(this.t(schema + ".h2"));
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

  searchFor: function(model) {
    return this.config(model.get("schema")).search;
  },

  config: function(type) {
    return {
      "account": { profileBox: AccountProfileBox, 
                   collection: this.options.community.users,
                   search: this.options.community.search.users
                 },
      "user":  { profileBox: UserProfileBox, 
                 collection: this.options.community.users,
                 search: this.options.community.search.users
               },
      "group": { profileBox: GroupProfileBox, 
                 collection: this.options.community.groups,
                 search: this.options.community.search.groups
               },
      "feed": { profileBox: FeedProfileBox, 
                collection: this.options.community.feeds,
                search: this.options.community.search.feeds
              } 
    }[type];    
  },

  switchTab: function(e) {
    e && e.preventDefault();
    this.showList(this.getSchema($(e.target)));
  },

  filterBySearch: function(e) {
    e && e.preventDefault();
    query = this.$("form > input").val();
    if (query) {
      this.$(".remove-search").show();
      this.$(".remove-search").text(query);
      this.currentQuery = query;
      this.showList(this.getSchema());
    } else { this.removeSearch(); }
  },

  removeSearch: function(e) {
    e && e.preventDefault();
    this.$(".remove-search").hide();
    this.currentQuery = "";
    this.$("form > input").val("");
    this.showList(this.getSchema());
  },

  getSchema: function(el) {
    el = el ? el : $(".filter-tab.current");
    return el.attr("href").split("#")[1];
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
