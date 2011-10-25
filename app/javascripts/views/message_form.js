var MessageFormView = FormView.extend({
  template: "shared/message-form",

  save: function(callback) {
    var self = this;
    this.model.save({
      subject: this.$("[name=subject]").val(),
      body: this.$("[name=body]").val()
    }, {
      success: function() { callback(); },
      error: function(attribs, response) { self.showError(response); }
    });
  },
  
  showError: function(response) {
    console.log(response);
    this.$(".error").text(response.responseText);
    this.$(".error").show();
  },

  name: function() {
    return this.model.name();
  }
});


