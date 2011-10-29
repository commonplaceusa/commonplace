var PostFormView = FormView.extend({
  save: function(callback) {
    var self = this;
    this.model.save({
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val()
    }, {
      success: callback,
      error: function(attribs, response) { self.showError(response); }
    });
  },
  
  showError: function(response) {
    this.$(".error").text(response.responseText);
    this.$(".error").show();
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


