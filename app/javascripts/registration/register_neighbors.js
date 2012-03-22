var RegisterNeighborsView = RegistrationModalPage.extend({
  template: "registration.neighbors",
  
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
            this.generate(this.data.isFacebook);
          }
        }, this)
      );
    }, this));
  },
  
  nextPageTrigger: function() {
    this.nextPageThrottled = _.once(_.bind(function() { this.nextNeighborsPage(); }, this));
  },
  
  generate: function(checkFacebook) {
    this.currentQuery = "";
    this.$(".no_results").hide();
    this.$(".search_finder").hide();
    this.$(".neighbor_finder table").empty();
    this.$("initial_load").show();
    
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
      this.limit += 100;
      this.$(".initial_load").hide();
      this.nextPageThrottled();
    }
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
        url: "/api" + CommonPlace.account.link("neighbors"), 
        data: JSON.stringify(data), 
        contentType: "application/json",
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
  
  debounceSearch: _.debounce(function() {
    this.search();
  }, CommonPlace.autoActionTimeout),
  
  search: function() {
    this.$(".no_results").hide();
    this.showGif("loading");
    this.currentQuery = this.$("input[name=search]").val();
    if (!this.currentQuery) {
      this.removeSearch();
    } else {
      this.currentScroll = this.$(".neighbor_finder").scrollTop();
      this.$(".neighbor_finder").hide();
      this.$(".search_finder").show();
      this.$(".search_finder table").empty();
      $.getJSON(
        "/api" + this.communityExterior.links.registration.residents,
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
                addFromSearch: _.bind(function(el) { this.addFromSearch(el); }, this)
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
    }
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
  
  addFromSearch: function(el) {
    this.appendCell(this.$(".neighbor_finder table"), el);
    this.removeSearch();
    this.$(".neighbor_finder").scrollTo(el);
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
