var MessageFormView = FormView.extend({
  template: "shared/message-form",

  save: function(callback) {
    var self = this;
    this.model.save({
      subject: this.$("[name=subject]").val(),
      body: this.$("[name=body]").val()
    }, {
      success: function() { callback(); },
      error: function(attribs, response) { self.incomplete(response); }
    });
  },

  incomplete: function(fields) {
    var incompleteFields = fields.shift();
    var self = this;
    _.each(fields, function(f) {
      incompleteFields = incompleteFields + " and " + f;
    });
    this.$(".incomplete-fields").text(incompleteFields);
    this.$(".incomplete").show();
  },

  name: function() {
    return this.model.name();
  }
});


