var WireItem = CommonPlace.View.extend({

  set_thanked: function(increment, scope) {
    if (increment) {
      scope.$(".thank_count").html(scope.numThanks() + 1);
    }
    scope.$(".thank-link").html("Thanked!");
    scope.$(".thank-link").addClass("thanked-post");
  },

  thanked: function() {
    var thanks = _.map(this.model.get("thanks"), function(thank) { return thank.name; });
    if (_.include(thanks, CommonPlace.account.get("name"))) {
      this.set_thanked(false, this);
    }
  },

  thank: function() {
    if (this.thanked())
      return;
    var self = this;
    $.ajax({
      url: "/api/" + this.model.get("schema") + "/" + this.model.get("id") + "/thank",
      type: "POST",
      success: function() {
        self.set_thanked(true, self);
      }
    });
  }
});
