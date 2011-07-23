
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

CommonPlace.PostConfirmationView = Backbone.View.extend({
  id: "modal",
  tagname: "div",

  events: {
    "click .submit": "confirm"
  },

  render: function() {
    $(this.el).addClass("not_empty");
    $(this.el).append('<div id="modal-overlay"></div>');
    $(this.el).append('<div id="modal-content"></div>');
    this.$("#modal-content").append('<img src="/images/modal-close.png" id="modal-close">');
    this.$("#modal-content").append(CommonPlace.render("post_confirmation_form", {
        'title': this.options.subject,
        'body': this.options.body,
        id: 0,
        avatar_url: CommonPlace.account.attributes.avatar_url,
        author: CommonPlace.account.attributes.short_name
}));
    $("#main").append(this.el);
    $(window).trigger('resize.modal');
    return this;
  },

  confirm: function(e) {
    // Submit the post
    // Dismiss modal dialog
    this.remove();
    $("input.create").replaceWith("<img src=\"/images/loading.gif\">");
    if (!this.$("input#commercial").is(':checked')) {
      CommonPlace.community.posts.create({
        title: this.options.subject,
        body: this.options.body
      }, { success: function() {
          window.location.hash = "/posts/new";
          Backbone.history.checkUrl();
          window.location.hash = "/posts";
          Backbone.history.checkUrl();
        }, error: function() { self.render(); }
      });
    } else {
        CommonPlace.community.announcements.create({
          title: this.options.subject,
            body: this.options.body,
            feed: null
        }, { success: function() {
            window.location.hash = "/announcements";
            Backbone.history.checkUrl();
            window.location.hash = "/announcements/new";
            Backbone.history.checkUrl();
        } });
    }
  },

  cancel: function(e) {
    // Dismiss the modal box
    console.log("Dismissing modal box");
    this.remove();
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
    if (this.options.model_type == "event") {
      this.model.attributes.occurs_on_date = this.model.attributes.occurs_on.split("T")[0];
    }
    this.$("#modal-content").append(CommonPlace.render("edit_" + this.options.model_type + "_form", this.model.attributes));
    $("#main").append(this.el);
    if (this.options.model_type == "event") {
      $('select#event_start_time>option[value="' + this.model.attributes.starts_at.replace("P", " P").replace("A", " A") + 'M"]').attr('selected', 'selected');
      $('select#event_end_time>option[value="' + this.model.attributes.ends_at.replace("P", " P").replace("A", " A") + 'M"]').attr('selected', 'selected');
      $("input.date").datepicker({dateFormat: 'yy-mm-dd'}); 
    }
    $(window).trigger('resize.modal');
    return this;
  },

  submitEdit: function(e) {
    e.preventDefault();
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
      fields.title = this.$("form input#event_title").val();
      fields.body = this.$("form input#event_body").val();
      // TODO: I don't think this is right
      fields.occurs_on = this.$("form input#event_date").val();
      fields.starts_at = this.$("form select#event_start_time").val();
      fields.ends_at = this.$("form select#event_end_time").val();
      fields.venue = this.$("form input#event_venue").val();
      fields.address = this.$("form input#event_address").val();
      fields.tags = this.$("form input#event_tags").val();
      console.log(fields);
    }
    model.save(fields, callbacks);
    this.remove();
  }
});
