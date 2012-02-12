var RegisterNeighborsView = CommonPlace.View.extend({
  template: "registration.neighbors",
  
  events: {
    "click input.continue": "submit",
    "submit form": "submit"
  },
  
  afterRender: function() {
    this.options.slideIn(this.el);
  },
  
  submit: function() {}
});
