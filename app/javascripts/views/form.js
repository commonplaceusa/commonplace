
var FormView = CommonPlace.View.extend({
  initialize: function(options) {
    this.template = (this.options.template || this.template);
    this.modal = new ModalView({form: this.el});
  },

  afterRender: function() {
    this.modal.render();
  },

  events: {
    "click form a.cancel": "exit",
    "click form a.delete": "deletePost",
    "submit form": "send"
  },

  send: function(e) {
    e.preventDefault();
    this.save();
    this.exit();
  },

  exit: function(e) {
    e && e.preventDefault();
    this.modal.exit();
  },

  deletePost: function(e) {
    e && e.preventDefault();
    var self = this;
    this.remove(function() { self.modal.exit(); });
  }
});


