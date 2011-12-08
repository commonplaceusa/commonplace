//= require_tree ./shared

function onABCommComplete() {
  text = "";
  $($("textarea#invite_email").val().split(", "))
    .each(function(index, value) { text += value.replace(/(.*)<(.*)>/, "$2") + ", "; });
  $("textarea#invite_email").val(text.substring(0, text.length-2));
}

var InvitePage = Backbone.View.extend({
  
  render: function() {
    this.$('input[placeholder], textarea[placeholder]').placeholder();
    this.$('textarea').autoResize();
    return this;
  },

  events: {
    "click a.find-on-facebook-button": "findOnFacebook",
    "click a.share-on-facebook-button": "shareOnFacebook",
    "click a.import-contacts-from-email-button": "importContacts",
    "submit form.send-invites": "sendInvites"
  },

  findOnFacebook: function(e) {
    e.preventDefault();
    FB.login(
      function() {
        FB.ui({
          method: "apprequests",
          message: $(e.target).attr("data-message"),
          data: $(e.target).attr("data-slug"),
          display: "iframe"
        });
      },
      {perms:'read_stream,publish_stream,offline_access'}
    );
  },

  shareOnFacebook: function(e) {
    e.preventDefault();
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
  },

  importContacts: function(e) {
    e.preventDefault();
    showPlaxoABChooser("invite_emails", "/plaxo-importer.html");
  },

  sendInvites: function(e) {
    e.preventDefault();
    var $form = this.$("form.send-invites");
    $.ajax({
      type: "POST",
      dataType: "json",
      url: "/api/communities/" + $form.attr("data-community-id") + "/invites",
      data: JSON.stringify({
        emails: $("[name=email]", $form).val().split(/,\s*/),
        message: $("[name=body]", $form).val()
      }),
      success: function() {
        $("[name=email]", $form).val("");
        $("[name=body]", $form).val("");
        $("p.confirm", $form).show().delay(1000).fadeOut();
      }
    });
  }
});

// Initialization

$(function() {
  if ($("body").hasClass("invite")) {
    var view = new InvitePage({el: $("#main")});
    window.view = view;
    view.render();
  }
});


