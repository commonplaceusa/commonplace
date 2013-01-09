var MessageFormView = FormView.extend({
  template: "shared/message-form",
  goToInbox: false,

  save: function(callback) {
    var self = this;
    var oldHTML = this.$("#message_controls").html();
    this.$("#message_controls button").replaceWith("<img src='/assets/loading.gif' />");
    this.model.save({
      subject: this.$("[name=subject]").val(),
      body: this.$("[name=body]").val()
    }, {
      wait: true,
      success: function(model, response) {
        if (typeof _kmq !== "undefined" && _kmq !== null) {
          _kmq.push(['record', 'Sent Message']);
        }
        this.$("#message_controls").html(oldHTML);
        callback();
        if (self.goToInbox) {
          window.location = '/' + CommonPlace.community.get("slug") + '/inbox#' + response;
        }
      },
      error: function(attribs, response) {
        this.$("#message_controls").html(oldHTML);
        self.showError(response);
      }
    });
  },

  showError: function(response) {
    this.$(".error").text(response.responseText);
    this.$(".error").show();
  },

  name: function() {
    return this.model.name();
  }
});


