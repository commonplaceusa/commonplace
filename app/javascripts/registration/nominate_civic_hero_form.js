var NominateCivicHeroForm = CommonPlace.View.extend({
  template: "registration.nominate_civic_hero",

  events: {
    "click button.next-button": "submit",
    "blur :input": "inputBlur",
    "focus :input": "inputFocus"
  },

  initialize: function() {
    this.data = {};
    this.placeholder_support = false;
    var test = document.createElement("input");
    if('placeholder' in test) this.placeholder_support = true;
  },

  afterRender: function () {
    $(":input").blur();
  },

  inputFocus: function (e) {
    if (e) { e.preventDefault(); }

    if (!this.placeholder_support) {
      if ($(e.target).attr('placeholder') != "" && $(e.target).val() == $(e.target).attr('placeholder')) {
        $(e.target).val("").removeClass("hasPlaceholder");
      }
    }
  },
      
  inputBlur: function (e) {  
    if (e) { e.preventDefault(); }

    if (!this.placeholder_support) {

      if ($(e.target).attr('placeholder') != '' && ($(e.target).val() == '' || $(e.target).val() == $(e.target).attr('placeholder'))) {
        $(e.target).val($(e.target).attr('placeholder')).addClass('hasPlaceholder');
      }
    }
  },

  submit: function(e) {
    if (e) { e.preventDefault(); }

    $(e.target).find('.hasPlaceholder').each(function() { $(e.target).val(''); });
    var self = this;
    _.each(["nominee_name", "nominee_email", "nomination_reason", "nominator_name", "nominator_email"], function(data_point) {
      self.data[data_point] = self.$("[name=" + data_point + "]").val();
    });

    var post_api = "/api" + this.options.communityExterior.links.registration.nominate_civic_hero;
    $.post(post_api, this.data, _.bind(function(response) {
      new ApplicationOrNominationSubmittedView({ el: $(this.options.el), nominee_name: self.$("[name=nominee_name]").val(), applying_or_nominating: "nominating" }).render();
    }, this));
  },

  continue: function() {

  }

});
