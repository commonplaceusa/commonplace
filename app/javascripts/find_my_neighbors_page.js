var FindMyNeighborsPage = CommonPlace.View.extend({
  template: "find_my_neighbors_page.main",
  track: true,
  page_name: "find_my_neighbors",

  events: {
    "click img.facebook": "facebook",
    "click img.gmail": "gmail",
    
    "click .show_add_neighbor": "toggleAddNeighbor",
    "click form.add input.add_neighbor": "addNeighbor",
    "submit form.add": "addNeighbor",
    
    "click input.contact": "toggleContact",
    
    "keyup form.list input.search": "debounceSearch",
    "click form.list .remove_search.active": "removeSearch",
    "click form.list .no_results": "removeSearch",
    
    "click form.list input.continue": "submit",
    "submit form.list": "submit"
  },
  
  afterRender: function() {
    var self = this;
    GoogleContacts.prepare();
    this.currentQuery = "";
    
    this.$(".no_results").hide();
    this.$(".search_finder").hide();
    this.$(".initial_load").show();
    this.$(".neighbor_count_li").hide();
    this.$("form.add").hide();
    this.$("form.add .error").hide();
    
    this.nextPageTrigger();
    this.$(".neighbor_finder").scroll(function() {
      if (($(this).scrollTop() + 30) > (5 * this.scrollHeight / 7)) { self.nextPageThrottled(); }
    });
    
    $.getJSON(
      "/api" + CommonPlace.community.link("residents"), {},
      _.bind(function(response) {
        if (response.length) {
          this.neighbors = response;
          this.generate((CommonPlace.account.get("facebook_user")) ? "facebooK" : false);
        }
      }, this)
    );
  },

  nextPageTrigger: function() {
    this.nextPageThrottled = _.once(_.bind(function() { this.nextPage(); }, this));
  },
  
  generate: function(checkExternalService) {
    if (checkExternalService == "facebook") {
      facebook_connect_friends({
        success: _.bind(function(friends) {
          console.log(this.friends);
          this.friends = friends;
          console.log("Friends overwritten");
          console.log(this.friends);
          this.facebook_connected = true;
          this.generate(false);
        }, this)
      });
    } else if (checkExternalService == "gmail") {
      GoogleContacts.retrievePairedContacts({
        success: _.bind(function(friends) {
          console.log(this.friends);
          this.friends = friends;
          this.gmail_connected = true;
          console.log("Friends overwritten");
          console.log(this.friends);
          this.generate(false);
        }, this)
      });
    } else {
      this.items = [];
      this.limit = 0;
      this.neighbors = _.sortBy(this.neighbors, function(neighbor) { return neighbor.last_name; });
      _.each(this.neighbors, _.bind(function(neighbor) {
        var itemView = this.generateItem(neighbor, false);
        if (!itemView.isFacebook()) {
          this.items.push(itemView);
        } else {
          this.items.unshift(itemView);
          this.limit++;
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
    
    var itemView = new this.NeighborItemView({
      model: neighbor,
      intersectedUser: intersectedUser,
      search: isSearch,
      showCount: _.bind(function() { this.showCount(); }, this),
      addFromSearch: addFromSearch
    });
    itemView.options.intersectionType = "";
    if (this.facebook_connected)
      itemView.options.intersectionType = "facebook";
    if (this.gmail_connected)
      itemView.options.intersectionType = "gmail";
    return itemView;
  },

  nextPage: function() {
    if (_.isEmpty(this.items)) { return; }
    
    this.showGif("loading");
    
    var currentItems = _.first(this.items, this.limit);
    this.items = _.rest(this.items, this.limit);
    _.each(currentItems, _.bind(function(itemView, index) {
      itemView.render();
      this.appendCell(this.$(".neighbor_finder table"), itemView.el);
    }, this));
    this.nextPageTrigger();
    
    this.showCount();
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

    this.generate("facebook");
  },

  gmail: function(e) {
    if (e) { e.preventDefault(); }

    this.generate("gmail");
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
            (!itemView.isFacebook()) ? results.unshift(itemView) : results.push(itemView);
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
    
    this.$("form.add .error").hide();
    var full_name = this.$("form.add input[name=name]").val();
    var email = this.$("form.add input[name=email]").val();
    if (!full_name || !email || full_name.split(" ").length < 2 || !_.last(full_name.split(" "))) {
      return this.$("form.add .error").show();
    }
    
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
    this.$("form.add input[type=text]").val("");
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
