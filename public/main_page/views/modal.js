
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
    "click #modal-close": "remove",
    "submit form.edit": "submitEdit"
  },

  render: function() {
    $(this.el).addClass("not_empty");
    $(this.el).append('<div id="modal-overlay"></div>');
    $(this.el).append('<div id="modal-content"></div>');
    this.$("#modal-content").append('<img src="/images/modal-close.png" id="modal-close">');
    this.$("#modal-content").append(CommonPlace.render("edit_" + this.options.model_type + "_form", this.model.attributes));
    $("#main").append(this.el);
    $(window).trigger('resize.modal');
    return this;
  },

  submitEdit: function(e) {
    e.preventDefault();
    //$.post("/api/" + this.options.model_type + "s/" + this.options.model.id + "/edit",
    //       JSON.stringify({ title: this.$("form input#post_subject").val(),
    //                        body: this.$("form textarea#post_body").val() }),
    //       function() {});
    var model_type = this.options.model_type;
    model = this.options.model;
    fields = {};
    callbacks = {
      success: function(){window.location.hash = "/" + model_type + "s/" + model.id;},
      error: function(){CommonPlace.app.notify("Your " + model_type + " could not be saved.");}
    };
    if (this.options.model_type == "post") {
      fields.title = this.$("form input#post_title").val();
      fields.body = this.$("form textarea#post_body").val();
    }
    if (this.options.model_type == "event") {

    }
    model.save(fields, callbacks);
    this.remove();
  }
});
