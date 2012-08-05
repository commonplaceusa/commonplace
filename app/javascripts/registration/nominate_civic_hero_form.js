var NominateCivicHeroForm = CommonPlace.View.extend({
  template: "registration.nominate_civic_hero",

  events: {
    "click button.next-button": "submit"
  },

  initialize: function() {
    this.data = {};
  },

  submit: function(e) {
    if (e) { e.preventDefault(); }

    var self = this;
    _.each(["nominee_name", "nominee_email", "nomination_reason", "nominator_name", "nominator_email"], function(data_point) {
      self.data[data_point] = self.$("[name=" + data_point + "]").val();
    });

    console.log(this.data);

    var post_api = "/api" + this.options.communityExterior.links.registration.nominate_civic_hero;
    $.post(post_api, this.data, _.bind(function(response) {
      alert("Thanks :)");
    }, this));
  }

});
