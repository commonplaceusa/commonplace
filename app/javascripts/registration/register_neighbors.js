var RegisterNeighborsView = CommonPlace.View.extend({
  template: "registration.neighbors",
  
  events: {
    "click input.continue": "submit",
    "submit form": "submit"
  },
  
  afterRender: function() {
    this.options.slideIn(this.el);
  },
  
  submit: function() {},
  
  NeighborItemView: CommonPlace.View.extend({
    template: "registration.user-item",
    tagName: "td",
    
    avatar_url: function() { return "/assets/block.png"; },
    first_name: function() { return "Joshles"; },
    last_name: function() { return "Lewis"; },
    
    isUser: function() { return false; }
  })
});
