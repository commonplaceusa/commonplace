var ShareView = CommonPlace.View.extend({
  className: "share",
  template: "shared/share",
  initialize: function(options) {
    var self = this;
    this.account = options.account;
  },
  
  afterRender: function() {
  }, 

  events: {
    "click .share-e": "showEmailShare",
    "click .share-f": "shareFacebook",
    "click .share-t": "shareTwitter",
    "click .email-button": "submitEmail"
  },

  shared: function() {
    console.log("Hiding");
    this.$(".share").hide();
    console.log("Done!");
  },

  shareFacebook: function(e) {
    e.preventDefault();
    console.log("Sharing on Facebook");
    var $link = $(e.target);
    FB.ui({
      method: 'feed',
      name: $link.attr("data-name"),
      link: $link.attr("data-url"),
      picture: $link.attr("data-picture"),
      caption: $link.attr("data-caption"),
      description: $link.attr("data-description"),
      message: $link.attr("data-message")
    }, $.noop);
    this.shared();
  },

  shareTwitter: function(e) {
    e.preventDefault();
    var $link = $(e.target);
    var url = $link.attr("data-url");
    var text = $link.attr("data-message");
    console.log("Sharing on Twitter");
    var share_url = "http://twitter.com/share?url=" + url + "&text=" + text + "&count=horizontal";
    window.open(share_url, "cp_share");
    this.shared();
  },

  showEmailShare: function(e) {
    e.preventDefault();
    console.log("Showing email");
    this.$("#share-email").show();
  },

  submitEmail: function(e) {
    if (e)
      e.preventDefault();
    console.log("Submitting the share via e-mail");
    var $form = this.$("form");
    var self = this;
    $.ajax({
      type: "POST",
      dataType: "json",
      url: "/api" + CommonPlace.community.link("shares"),
      data: JSON.stringify({
        data_type: this.model.get("schema"),
        id: this.model.get("id"),
        email: $("[name=share-email]", $form).val()
      }),
      success: function() {
        $("[name=share-email", $form).val("");
        $form.hide();
        self.shared();
      },
      failure: function() {
        $form.hide();
        self.shared();
      }
    });
  }
});
