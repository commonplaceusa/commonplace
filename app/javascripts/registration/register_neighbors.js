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
  },
  
  afterRender: function() {
    this.options.slideIn(this.el);
    this.getPage();
  },
  
  getPage: function() {
    $.getJSON(
      "/api" + this.options.communityExterior.links.registration.residents,
      { page: this.page },
      _.bind(function(response) {
        
        if (response.length == 0) {
          if (this.page == 0) { this.options.finish(); }
        } else {
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
    var $lastRow = $table.children("tr").last();
    if (this.page && $table[0].rows.length && $lastRow[0].cells.length == 1) {
      var itemView = neighbors.shift();
      itemView.render();
      $lastRow.append(itemView.el);
    }
    
    _.each(neighbors, _.bind(function(itemView, index) {
      itemView.render();
      
      if (index % 2 == 0) { $row = $($table[0].insertRow(-1)); }
      $row.append(itemView.el);
    }, this));
  },
  
  submit: function() {
    var neighbors = _.map(this.$("input[name=neighbors_list]:checked"), function(neighbor) {
      return { name: $(neighbor).val(); }
    });
    if (neighbors.length) {
      $.post("/api" + CommonPlace.account.link("neighbors"), neighbors, _.bind(function() {
        this.options.finish();
      }, this));
    } else { this.options.finish(); }
  },
  
  facebook: function(e) {
    if (e) { e.preventDefault(); }
    
    facebook_connect_post_registration({
      success: _.bind(function(response) {
        var data = {
          isFacebook: true,
          friends: response.friends
        };
        this.nextPage("neighbors", data);
      }, this)
    });
  },
  
  isFacebookUser: function(name) {
    if (!this.options.data || !this.options.data.isFacebook) { return false; }
    return _.any(this.options.data.friends, function(friend) {
      return friend.name.toLowerCase() == name.toLowerCase();
    });
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
      $checkbox.toggleClass("checked");
    }
  })
});
