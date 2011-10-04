var PostFormView = FormView.extend({
  save: function(callback) {
    var self = this;
    this.model.save({
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val()
    }, {
      success: callback,
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

  remove: function(callback) {
    this.model.destroy({ success: callback });
  },

  title: function() {
    return this.model.get("title");
  },

  body: function() {
    return this.model.get("body");
  }
});


