
MobileView = CommonPlace.View.extend({
  
  template: "mobile.mobile-view",

  hello: function() { return "world"; }

});


$(function() {

  var view = new MobileView({ el: $("#main") });

  view.render();
});
