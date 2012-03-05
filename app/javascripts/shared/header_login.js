var HeaderLogin = CommonPlace.View.extend({
  template: "shared.header-login",
  id: "user_sign_in",
  tagName: "ul",
  
  events: {
    "click #sign_in_button": "toggleForm",
    "click input.submit": "login",
    "submit form": "login"
  },
  
  afterRender: function() {
    this.$("#sign_in_form").hide();
  },
  
  toggleForm: function(e) {
    if (e) { e.preventDefault(); }
    if (this.$("#sign_in_form:visible").length) {
      this.$("#sign_in_form").hide();
    } else {
      this.$("#sign_in_form").show();
    }
  },
  
  login: function(e) {
    if (e) { e.preventDefault(); }
    this.$(".error").removeClass("error");
    
    var email = this.$("input[name=email]").val();
    if (!email) { return this.$("label[name=email]").addClass("error"); }
    
    var password = this.$("input[name=password]").val();
    if (!password) { return this.$("label[name=password]").addClass("error"); }
    
    $.postJSON({
      url: "/api/sessions",
      data: { email: email, password: password },
      success: function() { document.location.reload(); },
      error: _.bind(function() { this.$("label").addClass("error"); }, this)
    });
  }

});
