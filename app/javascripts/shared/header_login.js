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
  
  create_error: function(text) {
    return "<li class='error'>" + text + "</li>";
  },
  login: function(e) {
    if (e) { e.preventDefault(); }
    this.$("#errors").html("");
    this.$(".error").removeClass("error");
    
    var email = this.$("input[name=email]").val();
    if (!email) {
      this.$("#errors").append(this.create_error("Please enter an e-mail address"));
      this.$("label[name=email]").addClass("error");
      return;
    }
    
    var password = this.$("input[name=password]").val();
    if (!password) {
      this.$("#errors").append(this.create_error("Please enter a password"));
      this.$("label[name=password]").addClass("error");
      return;
    }
    
    $.postJSON({
      url: "/api/sessions",
      data: { email: email, password: password },
      success: function() { document.location.reload(); },
      error: _.bind(function() {
        this.$("#errors").append(this.create_error("Invalid login! Please try again."))
        this.$("label").addClass("error");
      }, this)
    });
  }

});
