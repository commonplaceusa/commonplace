
MobileView = CommonPlace.View.extend({
  
  template: "mobile.landing",

  hello: function() { return "world"; }

});


$(function() {

  var view = new LandingView({ el: $("#main") });
  view.render();
});
