
CommonPlace.NewMessage = Backbone.View.extend({
  id: "modal",
  tagName: "div",

  events: { 
    "click #modal-close": "remove",
    "submit form.message": "submitMessage"
  },

  render: function() {
    $(this.el).addClass("not_empty");
    $(this.el).append('<div id="modal-overlay"></div>');
    $(this.el).append('<div id="modal-content"></div>');
    this.$("#modal-content").append('<img src="/images/modal-close.png" id="modal-close">');
    this.$("#modal-content").append(CommonPlace.render("message_form"));
    $("#main").append(this.el);
    $(window).trigger('resize.modal');
    return this;
  },

  submitMessage: function(e) {
    e.preventDefault();
    $.post("/api/people/" + this.options.person_id + "/messages",
           JSON.stringify({ subject: this.$("form input#message_subject").val(),
                            body: this.$("form textarea#message_body").val() }),
           function() {});
    this.remove();
  }

});