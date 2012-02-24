var FindMyNeighborsPage = CommonPlace.View.extend({
  template: "find_my_neighbors_page.main",
  track: true,
  page_name: "find_my_neighbors",

  events: {
    "click input.continue": "submit",
    "submit form": "submit",
    "click img.facebook": "facebook",
    "keyup input.search": "debounceSearch",
    "click .remove_search.active": "removeSearch",
    "click .no_results": "removeSearch",
    "click input.contact": "toggleContact"
  },
  
  afterRender: function() {
    var self = this;
    this.currentQuery = "";
    
    this.$(".no_results").hide();
    this.$(".search_finder").hide();
    this.nextPageTrigger();
    this.$(".neighbor_finder").scroll(function() {
      if (($(this).scrollTop() + 30) > (5 * this.scrollHeight / 7)) { self.nextPageThrottled(); }
    });
    
    $.getJSON(
      "/api" + CommonPlace.community.link("residents"), {},
      _.bind(function(response) {
        if (response.length) {
          this.neighbors = response;
          this.generate(CommonPlace.account.get("facebook_user"));
        }
      }, this)
    );
  },

  nextPageTrigger: function() {
    this.nextPageThrottled = _.once(_.bind(function() { this.nextPage(); }, this));
  },
  
  generate: function(checkFacebook) {
    if (checkFacebook) {
      facebook_connect_friends({
        success: _.bind(function(friends) {
          this.friends = friends;
          this.generate(false);
        }, this)
      });
    } else {
      this.items = [];
      this.limit = 0;
      _.each(this.neighbors, _.bind(function(neighbor) {
        var fbUser = this.getFacebookUser(neighbor.first_name + " " + neighbor.last_name);
        var itemView = new this.NeighborItemView({
          model: neighbor,
          fbUser: fbUser,
          search: false
        });
        if (_.isEmpty(fbUser)) {
          this.items.push(itemView);
        } else {
          this.items.unshift(itemView);
          this.limit++;
        }
      }, this));
      this.remaining = _.clone(this.items);
      this.limit += 100;
      this.nextPageThrottled();
    }
  },

  nextPage: function() {
    if (_.isEmpty(this.remaining)) { return; }
    
    this.showGif("loading");
    
    var currentItems = _.first(this.remaining, this.limit);
    this.remaining = _.rest(this.remaining, this.limit);
    _.each(currentItems, _.bind(function(itemView, index) {
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

  submit: function(e) {
    if (e) { e.preventDefault(); }
    
    if (this.currentQuery) { this.removeSearch(); }

    var data = {
      neighbors: _.map(this.$(".neighbor_finder input[name=neighbors_list]:checked"), function(neighbor) {
        return { name: $(neighbor).val() };
      }),
      can_contact: (this.$("input[name=can_contact]").attr("checked")) ? true : false
    };

    if (data.neighbors.length) {
      $.ajax({
        type: "POST",
        contentType: "application/json",
        url: "/api" + CommonPlace.account.link("neighbors"), 
        data: JSON.stringify(data), 
        success: _.bind(function() { this.finish(); }, this),
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
            var fbUser = this.getFacebookUser(neighbor.first_name + " " + neighbor.last_name);
            var itemView = new this.NeighborItemView({
              model: neighbor,
              fbUser: fbUser,
              search: true,
              addFromSearch: _.bind(function(el) {
                this.appendCell(this.$(".neighbor_finder table"), el);
                this.removeSearch();
                this.$(".neighbor_finder").scrollTo(el);
              }, this)
            });
            (!_.isEmpty(fbUser)) ? results.unshift(itemView) : results.push(itemView);
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

  finish: function() {
    window.location.pathname = "/" + CommonPlace.community.get("slug");
  },

  NeighborItemView: CommonPlace.View.extend({
    template: "find_my_neighbors_page.neighbor",
    tagName: "td",

    events: { "click": "check" },

    afterRender: function() {
      if (this.isFacebook()) {
        if (!this.options.search) { this.check(); }
        facebook_connect_user_picture({
          id: this.options.fbUser.id,
          success: _.bind(function(url) {
            this.$("img").attr("src", url);
          }, this)
        });
      }
    },

    avatar_url: function() { return "/assets/block.png"; },
    first_name: function() { return this.model.first_name; },
    last_name: function() { return this.model.last_name; },

    isFacebook: function() { return !_.isEmpty(this.options.fbUser); },

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
    }
  })
});
