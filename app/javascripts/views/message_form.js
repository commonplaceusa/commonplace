var MessageFormView = FormView.extend({
  template: "shared/message-form",
  goToInbox: false,

  save: function(callback) {
    var self = this;
    var oldHTML = this.$(".controls").html();
    this.$(".controls button").replaceWith("<img src='/assets/loading.gif' />");
    this.model.save({
      subject: this.$("[name=subject]").val(),
      body: this.$("[name=body]").val()
    }, {
      wait: true,
      success: function(model, response) {
        this.$(".controls").html(oldHTML);
        callback();
        if (self.goToInbox) {
          window.location = '/' + CommonPlace.community.get("slug") + '/inbox#' + response;
        }
      },
      error: function(attribs, response) {
        this.$(".controls").html(oldHTML);
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


