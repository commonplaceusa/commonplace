var FeedOwnersFormView = FormView.extend({
  template: "shared/feed-owners-form",

  events: {
    "click form a.cancel": "exit",
    "submit form": "addOwners"
  },

  afterRender: function() {
    this.modal.render();
    this.fillList();
  },

  fillList: function() {
    var list = this.$(".existing-owners");
    list.empty();
    var self = this;
    var owners = this.model.owners;
    owners.fetch({
      success: function() {
        owners.each(function(owner) {
          var item = new FeedOwnersItemView({ model: owner, form: self });
          item.render();
          list.append(item.el);
        });
      }
    });
  },

  addOwners: function(e) {
    e && e.preventDefault();

    // hiding the error notifications
    this.$(".incomplete-form").hide();
    this.$(".bad-emails").hide();

    var self = this;
    var emailform = this.$("[name=emails]");

    // unlike message/event modals, we're not validating a model
    // and $.post() doesn't have an error callback
    // so we check to see if the form is empty here
    if (emailform.val() == "") { return this.$(".incomplete-form").show(); }

    $.post(
      "/api" + this.model.link("owners"), 
      { emails: emailform.val() },
      function(response) {
        var bad_emails = _.select(emailform.val().split(","), function(email) {
          return !_.any(response, function(obj) {
            return obj.user_email == email.replace(/ /g, "");
          });
        });
        
        if (bad_emails.length) {
          self.$(".bad-emails").show();
          emailform.val(bad_emails);
        } else {
          emailform.val("");
        }

        self.fillList();
      },
      "JSON"
    );
  },

  name: function() { return this.model.get("name"); }
});

var FeedOwnersItemView = CommonPlace.View.extend({
  template: "shared/feed-owners-item",
  tagName: "tr",

  initialize: function(options) {
    this.model = options.model;
    this.form = options.form;
  },

  events: {
    "click .message": "sendMessage",
    "click .remove-owner": "removeOwner"
  },

  name: function() {
    return this.model.get("user_name");
  },

  sendMessage: function(e) {
    e.preventDefault();
    this.form.exit();
    var user = new User({
      links: {
        self: this.model.link("user")
      }
    });
    user.fetch({
      success: function() {
        var formview = new MessageFormView({
          model: new Message({messagable: user})
        });
        formview.render();
      }
    });
  },

  removeOwner: function(e) {
    e.preventDefault();
    var form = this.form;
    this.model.destroy({
      success: function() {
        form.fillList();
      }
    });
  }
});



