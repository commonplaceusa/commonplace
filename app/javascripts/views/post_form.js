var PostFormView = FormView.extend({
  save: function() {
    this.model.save({
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val()
    });
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


