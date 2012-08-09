var ApplyCivicLeaderForm = CommonPlace.View.extend({
  template: "registration.apply_civic_leader",

  events: {
    "click button.next-button": "submit"
  },

  initialize: function() {
    this.data = {};
  },

  submit: function(e) {
    if (e) { e.preventDefault(); }

    var self = this;
    _.each(["name", "email", "application_reason"], function(data_point) {
      self.data[data_point] = self.$("[name=" + data_point + "]").val();
    });

    var post_api = "/api" + this.options.communityExterior.links.registration.apply_civic_leader;
    $.post(post_api, this.data, _.bind(function(response) {
      new ApplicationOrNominationSubmittedView({ el: $(this.options.el), applying_or_nominating: "applying" }).render();
    }, this));
  }

});

