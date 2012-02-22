//= require_tree ./account_page
var AccountPage = CommonPlace.View.extend({
  template: "account_page/main",
  track: true,
  page_name: "account",

  events: {
    "click .controls button": "editAccount",
    "click .avatar a.delete": "deleteAvatar",
    "click .delete-account": "confirmDeleteAccount"
  },

  initialize: function() {
    this.model = CommonPlace.account;
  },


  afterRender: function() {
    this.$(".about").autoResize();

    var get_posts = this.model.get("neighborhood_posts");
    this.$("[name=get-posts][value='" + get_posts + "']").attr("checked", "checked");

    this.populateSelected(this.model.get("interests"), this.$("[name=interests]"));
    this.populateSelected(this.model.get("skills"), this.$("[name=skills]"));
    this.populateSelected(this.model.get("goods"), this.$("[name=goods]"));
    this.$("select.list").chosen();

    this.initAvatarUploader(this.$(".avatar .upload"));

  },

  populateSelected: function(list, el) {
    _.each(list, function(item) {
      var option = el.children("[value='" + item + "']");

      option.attr("selected", "selected");
    });

  },

  editAccount: function(e) {
    e && e.preventDefault();
    var self = this;

    var changes = {
      name: this.$("[name=full_name]").val(),
      about: this.$("[name=about]").val(),
      email: this.$("[name=email]").val(),
      interests: this.$("[name=interests]").val(),
      skills: this.$("[name=skills]").val(),
      goods: this.$("[name=goods]").val(),
      neighborhood_posts: this.$("[name=get-posts]:checked").val()
    };

    if (this.$("[name=password]").val()) {
      var pass = this.$("[name=password]").val();
      var redundant = this.$("[name=password-redundant]").val();
      if (pass == redundant) {
        changes.password = pass;
      } else {
        this.showError({
          status: 403,
          responseText: "Password and Password Confirmation don't match"
        });
        return;
      }
    }

    this.model.save(changes, {
      success: function() { self.showSuccess(); },
      error: function(m, response) { self.showError(response); }
    });

  },

  showSuccess: function() {
    this.render();
    this.$("select.list").chosen();
    this.$(".success").show();
    this.$(".error").hide();
    $(window).scrollTop(0);
  },

  showError: function(response) {
    this.$(".error").text(response.responseText);
    this.$(".error").show();
    this.$(".success").hide();
    $(window).scrollTop(0);
  },

  fullName: function() { return this.model.get("name"); },

  about: function() { return this.model.get("about"); },

  email: function() { return this.model.get("email"); },

  avatarUrl: function() { return this.model.get("avatar_url"); },

  interests: function() { return CommonPlace.community.get('interests'); },

  skills: function() { return CommonPlace.community.get('skills'); },

  goods: function() { return CommonPlace.community.get('goods'); },

  initAvatarUploader: function($el) {
    var self = this;
    var uploader = new AjaxUpload($el, {
      action: "/api" + self.model.link("avatar"),
      name: 'avatar',
      data: { },
      responseType: 'json',
      onChange: function(file, extension){},
      onSubmit: function(file, extension) {},
      onComplete: function(file, response) {
        self.model.set(response);
        self.render();
      }
    });
  },

  deleteAvatar: function(e) {
    var self = this;
    if (e) { e.preventDefault(); }
    this.model.deleteAvatar(function() {
      self.render();
    });
  },

  confirmDeleteAccount: function(e) {
    if (e) { e.preventDefault(); }
    var form = new DeleteAccountForm();
    form.render();
    var modal = new ModalView({
      form: form.el
    });
    modal.render();
  },

  bind: function() {
    $("body").addClass("account");
  },

  unbind: function() {
    $("body").removeClass("account");
  }
});
