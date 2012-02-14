var RegisterNeighborsView = CommonPlace.View.extend({
  template: "registration.neighbors",
  
  events: {
    "click input.continue": "submit",
    "submit form": "submit",
    "click a.facebook": "facebook",
    "click a.email": "email"
  },
  
  initialize: function(options) {
    //if (!CommonPlace.account.isAuth()) { return options.nextPage("new_user"); }
    this.neighbors = [];
  },
  
  aroundRender: function(render) {
    $.getJSON("/api" + this.options.communityExterior.links.residents, _.bind(function(response) {
      if (response.length == 0) {
        return this.options.finish();
      } else {
        _.each(response, _.bind(function(neighbor) {
          var itemView = this.NeighborItemView({
            model: neighbor,
            isFacebook: _.any(this.options.data.friends, function(friend) {
              return friend.name == neighbor.first_name + neighbor.last_name;
            })
          });
        }, this));
      }
    }, this));
  },
  
  afterRender: function() {
    this.options.slideIn(this.el);
    var row;
    
    _.each(this.neighbors, _.bind(function(itemView, index) {
      itemView.render();
      if (index % 2 == 0) { row = $("<tr />"); }
      row.append(itemView.el);
      if (index % 2) { this.$("table").append(row); }
    }, this));
  },
  
  submit: function() {},
  
  facebook: function(e) {
    if (e) { e.preventDefault(); }
    
    facebook_connect_post_registration({
      success: _.bind(function(data) {
        data.isFacebook = true;
        this.nextPage("neighbors", data);
      }, this)
    });
  },
  
  email: function(e) {
    if (e) { e.preventDefault(); }
    console.log("pulling from email is being deferred");
  },
  
  NeighborItemView: CommonPlace.View.extend({
    template: "registration.user-item",
    tagName: "td",
    
    avatar_url: function() { return "/assets/block.png"; },
    first_name: function() { return this.model.first_name; },
    last_name: function() { return this.model.last_name; },
    
    isUser: function() { return false; }
  })
});
