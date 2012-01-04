var WireItem = CommonPlace.View.extend({
  thank: function() {
    var self = this;
    $.ajax({
      url: "/api/" + this.model.get("schema") + "/" + this.model.get("id") + "/thank",
      type: "POST",
      success: function() {
        self.$(".thank_count").html(self.numThanks() + 1);
        self.$(".thank-link").html("Thanked!");
        self.$(".thank-link").css("color", "#888");
      }
    });
  }
});
