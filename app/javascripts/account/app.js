
var AccountRouter = Backbone.Router.extend({
  routes: {
    "": "show"
  },
  
  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
  },
  
  show: function() {
    var editview = new AccountEditView({ account: this.account, community: this.community });
    editview.render();
    $("#account-edit").replaceWith(editview.el);
  }
});

var AccountEditView = CommonPlace.View.extend({
  template: "account/edit",
  id: "account-edit",
  
  events: {
    "click .password": "showRedundant",
    "submit": "editAccount"
  },
  
  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
  },
  
  afterRender: function() {
    this.$("textarea").autoResize();
  },
  
  editAccount: function(e) {
    e && e.preventDefault();
    var self = this;
    
    var changes = {
      name: this.$("[name=full_name]").val(),
      about: this.$("[name=about]").val(),
      email: this.$("[name=email]").val()
    }
    
    if (this.$("[name=password]").val()) {
      var pass = this.$("[name=password]").val();
      var redundant = this.$("[name=password-redundant]").val();
      if (pass == redundant) {
        changes.password = pass;
      } else {
        this.showError({
          status: 403,
          responseText: "emails don't match"
        });
        return;
      }
    }
    
    console.log(changes);
    
    this.account.save(changes, {
      success: function() { self.render(); },
      error: function(m, response) { self.showError(response); }
    });
  },
  
  showError: function(response) {
    this.$(".error").text(response.responseText);
    this.$(".error").show();
  },
  
  fullName: function() { return this.account.get("name"); },
  
  about: function() { return this.account.get("about"); },
  
  email: function() { return this.account.get("email"); },
  
  getsBulletin: function() { return false; },
  
  avatarUrl: function() { return this.account.get("avatar_url"); },
  
  showRedundant: function(e) {
    this.$(".password-redundant").show();
  }
});

