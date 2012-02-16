var RegisterNeighborsView = CommonPlace.View.extend({
  template: "registration.neighbors",
  
  events: {
    "click input.continue": "submit",
    "submit form": "submit",
    "click a.facebook": "facebook",
    "click a.email": "email"
  },
  
  initialize: function(options) {
    this.page = 0;
    this.data = options.data;
  },
  
  afterRender: function() {
    this.options.slideIn(this.el);
    var self = this;
    
    this.$(".neighbor_finder").scroll(function() {
      if (($(this).scrollTop() + 10) > (this.scrollHeight - $(this).height)) { self.nextPageThrottled(); }
    });
    
    if (this.data.isFacebook) {
      this.facebook();
    } else {
      this.nextPageTrigger();
      this.nextPageThrottled();
    }
  },
  
  nextPageTrigger: function() {
    this.nextPageThrottled = _.once(_.bind(function() { this.nextPage(); }, this));
  },
  
  nextPage: function() {
    $.getJSON(
      "/api" + this.options.communityExterior.links.registration.residents,
      { page: this.page, limit: 50 },
      _.bind(function(response) {
        
        if (response.length) {
          this.page++;
          var neighbors = [];
          _.each(response, _.bind(function(neighbor) {
            
            var isFacebookUser = this.isFacebookUser(neighbor.first_name + neighbor.last_name);
            var itemView = new this.NeighborItemView({
              model: neighbor,
              isFacebook: isFacebookUser
            });
            (isFacebookUser) ? neighbors.unshift(itemView) : neighbors.push(itemView);
            
          }, this));
          this.appendPage(neighbors);
        }
        
      }, this)
    );
  },
  
  appendPage: function(neighbors) {
    var $row;
    var $table = this.$("table");
    var $lastRow = $(_.last($table[0].rows));
    if (this.page && $table[0].rows.length && $lastRow[0].cells.length == 1) {
      var itemView = neighbors.shift();
      itemView.render();
      $lastRow.append(itemView.el);
    }
    
    _.each(neighbors, _.bind(function(itemView, index) {
      itemView.render();
      
      if (index % 2 === 0) { $row = $($table[0].insertRow(-1)); }
      $row.append(itemView.el);
    }, this));
    this.nextPageTrigger();
  },
  
  submit: function() {
    var neighbors = _.map(this.$("input[name=neighbors_list]:checked"), function(neighbor) {
      return { name: $(neighbor).val() };
    });
    if (neighbors.length) {
      $.post("/api" + CommonPlace.account.link("neighbors"), neighbors, _.bind(function() {
        this.options.finish();
      }, this));
    } else { this.options.finish(); }
  },
  
  facebook: function(e) {
    if (e) { e.preventDefault(); }
    
    facebook_connect_friends({
      success: _.bind(function(friends) {
        this.data = {
          isFacebook: true,
          friends: friends
        };
        console.log(this.data);
        this.$("tr").remove();
        this.page = 0;
        this.nextPageTrigger();
        this.nextPageThrottled();
      }, this)
    });
  },
  
  isFacebookUser: function(name) {
    if (!this.data || !this.data.isFacebook) { return false; }
    var result = _.any(this.data.friends, function(friend) {
      return friend.name.toLowerCase() == name.toLowerCase();
    });
    console.log(result, name);
    return result;
  },
  
  email: function(e) {
    if (e) { e.preventDefault(); }
    console.log("pulling from email is being deferred");
  },
  
  NeighborItemView: CommonPlace.View.extend({
    template: "registration.user-item",
    tagName: "td",
    
    events: { "click": "check" },
    
    afterRender: function() {
      if (this.options.isFacebook) { this.check(); }
    },
    
    avatar_url: function() { return "/assets/block.png"; },
    first_name: function() { return this.model.first_name; },
    last_name: function() { return this.model.last_name; },
    
    check: function(e) {
      if (e) { e.preventDefault(); }
      var $checkbox = this.$("input[type=checkbox]");
      if ($checkbox.attr("checked")) {
        $checkbox.removeAttr("checked");
      } else { $checkbox.attr("checked", "checked"); }
      $(this.el).toggleClass("checked");
    }
  })
});
