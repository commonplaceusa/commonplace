
var User = Model.extend({

  profileHistory: function(callback) {
    $.ajax({
      type: "GET",
      contentType: "application/json",
      url: "/api" + this.link('history'),
      success: callback
    });
  }

});

var Users = Collection.extend({
  model: User
});
