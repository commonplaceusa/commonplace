var MessageFormView = FormView.extend({
  template: "shared/message-form",

  save: function() {
    this.model.save({
      subject: this.$("[name=subject]").val(),
      body: this.$("[name=body]").val()
    });
  },

  name: function() {
    return this.model.name();
  }
});


