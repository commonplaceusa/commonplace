var RegisterNeighborsView = RegistrationModalPage.extend({
  template: "registration.neighbors",

  is_callback: false,
  callback_token: undefined,
  callback_verifier: undefined,
  ConsentToken: undefined,
  exp: undefined,
  lid: undefined,
  delt: undefined,
  
  events: {
    "click input.continue": "submit",

    "click img.facebook": "facebook",
    "click img.google": "gmail",
    "click img.yahoo": "yahoo",
    "click img.windows_live": "windows_live",

    "click li.add .addb": "addNeighbor",

    "click input.contact": "toggleContact",

    "keyup form.list input.search": "debounceSearch",
    "click form.list .remove_search.active": "removeSearch",

    "submit form.list": "submit",
  },

  email_address_contains: function(email, string) {
    return email && (email.indexOf(string) != -1);
  },

  is_google_user: function(email_address) {
    return (this.email_address_contains(email_address, "@gmail") || this.email_address_contains(email_address, "@google"));
  },

  is_yahoo_user: function(email_address) {
    return this.email_address_contains(email_address, "@yahoo");
  },

  is_windows_live_user: function(email_address) {
    return (this.email_address_contains(email_address, "@hotmail") || this.email_address_contains(email_address, "@live"));
  },
  
  afterRender: function() {
    var self = this;
    if (this.is_google_user(this.options.data.email)) {

      GoogleContacts.prepare({
        success: _.bind(function(friends) {
            this.friends = friends;
            this.gmail_connected = true;
            this.generate(false);
          }, this)
        });
      this.$("img.google").show();
    }
    else if (this.is_yahoo_user(this.options.data.email)) {
      YahooContacts.prepare({
          success: _.bind(function(friends) {
            this.friends = friends;
            this.yahoo_connected = true;
            this.generate(false);
          }, this)
        });
      this.$("img.yahoo").show();
    }
    else if (this.is_windows_live_user(this.options.data.email)) {
      WindowsLiveContacts.prepare({
          success: _.bind(function(friends) {
            this.friends = friends;
            this.windows_live_connected = true;
            this.generate(false);
          }, this)
        });
      this.$("img.windows_live").show();
    }
    this.currentQuery = "";

    this.$(".no_results").hide();
    this.$(".search_finder").hide();
    this.$(".initial_load").show();
    this.$(".neighbor_count_li").hide();
    this.$("form.add").hide();
    this.$("form.add .error").hide();


    
    this.$(".neighbor_finder").scroll(function() {
      if (($(this).scrollTop() + 30) > (5 * this.scrollHeight / 7)) { self.nextPageThrottled(); }
    });
    this.nextPageTrigger();
    
    this.slideIn(this.el, _.bind(function() {
      $.getJSON(
        "/api" + this.communityExterior.links.registration.residents, {limit: 3000},
        _.bind(function(response) {
          if (response.length) {
            this.neighbors = response;
            this.generate(this.options.data.isFacebook);
          }
        }, this)
      );
    }, this));
  },
  
  nextPageTrigger: function() {
    this.nextPageThrottled = _.once(_.bind(function() { this.nextNeighborsPage(); }, this));
  },
    
  generate: function(checkExternalService) {
    if (checkExternalService == "facebook") {
      facebook_connect_friends({
        success: _.bind(function(friends) {
          this.friends = friends;
          this.facebook_connected = true;
          this.generate(false);
        }, this)
      });
    } else if (checkExternalService == "gmail") {
      GoogleContacts.retrievePairedContacts();
    } else if (this.is_callback) {
      if (!(this.callback_verifier === undefined)) {
        // Yahoo!
        YahooContacts.retrievePairedContacts(this.callback_verifier);
      } else {
        // Windows Live
        WindowsLiveContacts.retrievePairedContacts(this.ConsentToken, this.exp, this.lid, this.delt);
      }
      this.is_callback = false;
    } else {
      this.items = [];
      this.limit = 0;
      this.neighbors = _.sortBy(this.neighbors, function(neighbor) { return neighbor.last_name; });
      _.each(this.neighbors, _.bind(function(neighbor) {
        var itemView = this.generateItem(neighbor, false);
        if (itemView.isFacebook() || itemView.isGmail()) {
          this.items.unshift(itemView);
          this.limit++;
        } else {
          this.items.push(itemView);
        }
      }, this));
      this.limit += 100;
      this.$(".neighbor_finder table").empty();
      this.$(".initial_load").hide();
      this.nextPageThrottled();
    }
  },

  generateItem: function(neighbor, isSearch) {
    var intersectedUser = this.getIntersectedUser(neighbor);
    var addFromSearch;

    if (isSearch) {
      addFromSearch = _.bind(function(el) {
        this.appendCell(this.$(".neighbor_finder table"), el);
        this.removeSearch();
        this.$(".neighbor_finder").scrollTo(el);
      }, this);
    } else {
      addFromSearch = function() {};
    }
    var intersectionType = "";
    if (this.facebook_connected)
      intersectionType = "facebook";
    if (this.gmail_connected)
      intersectionType = "gmail";
    if (this.yahoo_connected)
      intersectionType = "yahoo";
    if (this.windows_live_connected)
      intersectionType = "windows_live";
    var itemView = new this.NeighborItemView({
      model: neighbor,
      intersectedUser: intersectedUser,
      intersectionType: intersectionType,
      search: isSearch,
      showCount: _.bind(function() { this.showCount(); }, this),
      addFromSearch: addFromSearch
    });
    return itemView;
  },

  nextNeighborsPage: function() {
    if (_.isEmpty(this.items)) { return; }
    this.showGif("loading");
    
    var currentItems = _.first(this.items, this.limit);
    this.items = _.rest(this.items, this.limit);
    _.each(currentItems, _.bind(function(itemView) {
      itemView.render();
      this.appendCell(this.$(".neighbor_finder table"), itemView.el);
    }, this));
    this.nextPageTrigger();
    
    this.showGif("inactive");
  },
  
  appendCell: function($table, el) {
    var $row;
    var $lastRow = $(_.last($table[0].rows));
    
    if ($table[0].rows.length && $lastRow[0].cells.length == 1) {
      $row = $lastRow;
    } else { $row = $($table[0].insertRow(-1)); }
    
    $row.append(el);
  },


  facebook: function(e) {
    if (e) { e.preventDefault(); }

    this.generate("facebook");
  },

  gmail: function(e) {
    if (e) { e.preventDefault(); }
    this.generate("gmail");
  },

  yahoo: function(e) {
    if (e) { e.preventDefault(); }
    $.ajax({
      type: "POST",
      contentType: "application/json",
      url: "/api/contacts/authorization_url/yahoo",
      data: JSON.stringify({return_url: "" + CommonPlace.community.link("base") + "/" + CommonPlace.community.link("email_contact_authorization_callback")}),
      success: function(response) { window.location = response; }
    });
  },

  windows_live: function(e) {
    if (e) { e.preventDefault(); }
    $.ajax({
      type: "POST",
      contentType: "application/json",
      url: "/api/contacts/authorization_url/windows_live",
      data: JSON.stringify({return_url: "" + CommonPlace.community.link("base") + "/" + CommonPlace.community.link("email_contact_authorization_callback")}),
      success: function(response) { window.location = response; }
    });
  },

  getIntersectedUser: function(neighbor) {
    var name = neighbor.first_name + " " + neighbor.last_name;
    return _.find(this.friends, function(friend) {
      return friend.name.toLowerCase() == name.toLowerCase();
    });
  },

  debounceSearch: _.debounce(function() {
    this.search();
  }, CommonPlace.autoActionTimeout),


  search: function() {
    this.showGif("loading");
    this.$(".no_results").hide();
    this.currentQuery = this.$("input[name=search]").val();
    if (!this.currentQuery) {
      this.removeSearch();
    } else {
      this.currentScroll = this.$(".neighbor_finder").scrollTop();
      this.$(".neighbor_finder").hide();
      this.$(".search_finder").show();
      this.$(".search_finder table").empty();
      this.showSearch();
    }
  },

  showSearch: function() {
    $.getJSON(
      "/api" + CommonPlace.community.link("residents"),
      { limit: 100, query: this.currentQuery },
      _.bind(function(response) {
        this.showGif("active");
        if (!response.length) {
          this.$(".no_results").show();
          this.$(".query").text(this.currentQuery);
        } else {
          var results = [];
          _.each(response, _.bind(function(neighbor) {
            var itemView = this.generateItem(neighbor, true);
            (!itemView.isFacebook() || !itemView.isGmail()) ? results.unshift(itemView) : results.push(itemView);
          }, this));
          _.each(results, _.bind(function(itemView) {
            itemView.render();
            this.appendCell(this.$(".search_finder table"), itemView.el);
          }, this));
        }
      }, this)
    );
  },

  removeSearch: function(e) {
    if (e) { e.preventDefault(); }

    this.currentQuery = "";
    this.$("input[name=search]").val("");
    this.$(".search_finder").hide();
    this.$(".neighbor_finder").show();
    if (!this.$(".neighbor_finder").scrollTop()) {
      this.$(".neighbor_finder").scrollTo(this.currentScroll);
    }

    this.showGif("inactive");
  },



  toggleContact: function(e) {
    this.$("input.contact").removeAttr("checked");
    $(e.currentTarget).attr("checked", "checked");
  },

  showGif: function(className) {
    this.$(".remove_search").removeClass("inactive");
    this.$(".remove_search").removeClass("active");
    this.$(".remove_search").removeClass("loading");
    this.$(".remove_search").addClass(className);
  },

  showCount: function() {
    var count = this.$(".neighbor_finder input[name=neighbors_list]:checked").length;
    if (count) {
      this.$(".neighbor_count_li").show();
      this.$(".neighbor_count").text(count);
      this.$(".neighbor_count_li .plural").text( count === 1 ? "neighbor" : "neighbors" );
    } else {
      this.$(".neighbor_count_li").hide();
    }
  },

  toggleAddNeighbor: function(e) {
    if (e) { e.preventDefault(); }

    if (this.$("form.add:visible").length) {
      this.$("form.add").hide();
    } else {
      this.$("form.add").show();
      this.$("form.add .error").hide();
    }
  },

  addNeighbor: function(e) {
    if (e) { e.preventDefault(); }

    var full_name = $(e.target).siblings("input[name=name]").val();
    var email = $(e.target).siblings("input[name=email]").val();

    var neighbor = {
      full_name: full_name,
      first_name: _.first(full_name.split(" ")),
      last_name: _.last(full_name.split(" ")),
      email: email,
      avatar_url: undefined
    };

    var itemView = this.generateItem(neighbor, false);
    itemView.render();
    this.appendCell(this.$(".neighbor_finder table"), itemView.el);
    itemView.check();
    this.$(".neighbor_finder").scrollTo(itemView.el);
    $(e.target).siblings("input[type=text]").val("");
  },

  finish: function() {
    window.location.pathname = "/" + CommonPlace.community.get("slug");
  },

  NeighborItemView: CommonPlace.View.extend({
    template: "find_my_neighbors_page.neighbor",
    tagName: "td",

    events: { "click": "check" },

    initialize: function(options) {
      this._isFacebook = !_.isEmpty(this.options.intersectedUser) && this.options.intersectionType == "facebook";
      this._isGmail = !_.isEmpty(this.options.intersectedUser) && this.options.intersectionType == "gmail";
      this._isYahoo = !_.isEmpty(this.options.intersectedUser) && this.options.intersectionType == "yahoo";
      this._isWindowsLive = !_.isEmpty(this.options.intersectedUser) && this.options.intersectionType == "windows_live";
    },

    afterRender: function() {
      if (!this.model.on_commonplace) { this.$(".on-commonplace").hide(); }

      if (this.isFacebook()) {
        if (!this.options.search) { this.check(); }
        facebook_connect_user_picture({
          id: this.options.intersectedUser.id,
          success: _.bind(function(url) {
            this.$("img").attr("src", url);
          }, this)
        });
      }
      else if (this.isGmail()) {
        if (!this.options.search) { this.check(); }
      }
    },

    avatar_url: function() {
      if (this.model.on_commonplace) {
        return this.model.avatar_url;
      } else {
        return "https://s3.amazonaws.com/commonplace-avatars-production/missing.png";
      }
    },
    first_name: function() { return this.model.first_name; },
    last_name: function() { return this.model.last_name; },
    email: function() { return this.model.email; },
    facebook_id: function() { return this.isFacebook() && this.options.intersectedUser.id; },

    isFacebook: function() { return this._isFacebook; },
    isGmail: function() { return this._isGmail; },
    isYahoo: function() { return this._isYahoo; },
    isWindowsLive: function() { return this._isWindowsLive; },

    check: function(e) {
      if (e) { e.preventDefault(); }

      if (this.options.search) {
        this.options.search = false;
        this.options.addFromSearch(this.el);
      }

      var $checkbox = this.$("input[type=checkbox]");
      if ($checkbox.attr("checked")) {
        $checkbox.removeAttr("checked");
      } else { $checkbox.attr("checked", "checked"); }
      $(this.el).toggleClass("checked");

      this.options.showCount();
    }
  }),

  submit: function(e) {
    if (e) { e.preventDefault(); }

    if (this.currentQuery) { this.removeSearch(); }

    var data = {
      neighbors: _.map(this.$(".neighbor_finder input[name=neighbors_list]:checked"), function(neighbor) {
        return { name: $(neighbor).attr("data-name"), email: $(neighbor).attr("data-email") };
      }),
      can_contact: (this.$("input[name=can_contact]").attr("checked")) ? true : false
    };

    if (data.can_contact && this.facebook_connected)
    {
      var facebook_neighbors = _.map($(".neighbor_finder input[name=neighbors_list]:checked[data-facebook-id]"), function(elm) {
        return $(elm).attr("data-facebook-id");
      });
      var community_slug = CommonPlace.community.get('slug');
      var community_name = CommonPlace.community.get('name');
      FB.ui({
        method: 'apprequests',
        message: 'I joined The ' + community_name + ' CommonPlace, a new online community bulletin board for neighbors in ' + community_name + '. You should join too at: www.' + community_slug + '.OurCommonPlace.com.',
        data: community_slug,
        to: facebook_neighbors
      }, callback);
    }
    if (data.can_contact && (this.gmail_connected || this.yahoo_connected || this.windows_live_connected))
    {
      // TODO: Implement
    }

    if (data.neighbors.length) {
      $.ajax({
        type: "POST",
        contentType: "application/json",
        url: "/api" + CommonPlace.account.link("neighbors"), 
        data: JSON.stringify(data), 
        success: _.bind(function() { this.finish(); }, this)
      });
    } else {
      this.finish();
    }
  },  
  facebook: function(e) {
    if (e) { e.preventDefault(); }

    this.generate(true);
  },
  
  getFacebookUser: function(name) {
    return _.find(this.friends, function(friend) {
      return friend.name.toLowerCase() == name.toLowerCase();
    });
  },
  
  showGif: function(className) {
    this.$(".remove_search").removeClass("inactive");
    this.$(".remove_search").removeClass("active");
    this.$(".remove_search").removeClass("loading");
    this.$(".remove_search").addClass(className);
  },
  
  toggleContact: function(e) {
    this.$("input.contact").removeAttr("checked");
    $(e.currentTarget).attr("checked", "checked");
  },
  
  finish: function() { this.complete(); },


  NeighborItemView: CommonPlace.View.extend({
    template: "registration.neighbor-item",
    tagName: "td",

    events: { "click": "check" },

    initialize: function(options) {
      this._isFacebook = !_.isEmpty(this.options.intersectedUser) && this.options.intersectionType == "facebook";
      this._isGmail = !_.isEmpty(this.options.intersectedUser) && this.options.intersectionType == "gmail";
      this._isYahoo = !_.isEmpty(this.options.intersectedUser) && this.options.intersectionType == "yahoo";
      this._isWindowsLive = !_.isEmpty(this.options.intersectedUser) && this.options.intersectionType == "windows_live";
    },

    afterRender: function() {
      if (!this.model.on_commonplace) { this.$(".on-commonplace").hide(); }

      if (this.isFacebook()) {
        if (!this.options.search) { this.check(); }
        facebook_connect_user_picture({
          id: this.options.intersectedUser.id,
          success: _.bind(function(url) {
            this.$("img").attr("src", url);
          }, this)
        });
      }
      else if (this.isGmail()) {
        if (!this.options.search) { this.check(); }
      }
    },

    avatar_url: function() {
      if (this.model.on_commonplace) {
        return this.model.avatar_url;
      } else {
        return "https://s3.amazonaws.com/commonplace-avatars-production/missing.png";
      }
    },
    first_name: function() { return this.model.first_name; },
    last_name: function() { return this.model.last_name; },
    email: function() { return this.model.email; },
    facebook_id: function() { return this.isFacebook() && this.options.intersectedUser.id; },

    isFacebook: function() { return this._isFacebook; },
    isGmail: function() { return this._isGmail; },
    isYahoo: function() { return this._isYahoo; },
    isWindowsLive: function() { return this._isWindowsLive; },

    check: function(e) {
      if (e) { e.preventDefault(); }

      if (this.options.search) {
        this.options.search = false;
        this.options.addFromSearch(this.el);
      }

      var $checkbox = this.$("input[type=checkbox]");
      if ($checkbox.attr("checked")) {
        $checkbox.removeAttr("checked");
      } else { $checkbox.attr("checked", "checked"); }
      $(this.el).toggleClass("checked");

      this.options.showCount();
    }
  })
});
