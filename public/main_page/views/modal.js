
CommonPlace.NewMessage = Backbone.View.extend({
  id: "modal",
  tagName: "div",

  events: { 
    "click #modal-close": "remove",
    "submit form.message": "submitMessage"
  },

  render: function() {
    var self = this;
    if (CommonPlace.community.users.length === 0 && !this.options.loading) {
        CommonPlace.community.users.fetch(
            {success: function() {
                                     new CommonPlace.NewMessage({person_id: self.options.person_id, loading: true}).render();
            }});
        return;
    }
    $(this.el).addClass("not_empty");
    $(this.el).append('<div id="modal-overlay"></div>');
    $(this.el).append('<div id="modal-content"></div>');
    this.$("#modal-content").append('<img src="/images/modal-close.png" id="modal-close">');
    this.$("#modal-content").append(CommonPlace.render("message_form", {user_name: CommonPlace.community.users.get(this.options.person_id).get('name')}));
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
    _.delay(function(){CommonPlace.app.notify("Your message has been sent.");},200);
  }

});

CommonPlace.EditView = Backbone.View.extend({
  id: "modal",
  tagname: "div",

  events: { 
    "click #modal-close": "remove"
    //"submit form#edit_" + this.options.model_type: "submitEdit"
  },

  render: function() {
    $(this.el).addClass("not_empty");
    $(this.el).append('<div id="modal-overlay"></div>');
    $(this.el).append('<div id="modal-content"></div>');
    this.$("#modal-content").append('<img src="/images/modal-close.png" id="modal-close">');
    this.$("#modal-content").append(CommonPlace.render("edit_" + this.options.model_type + "_form", {model: this.options.model}));
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
    _.delay(function(){CommonPlace.app.notify("Your " + this.options.model_type + " has been edited.");},200);
  }
});
