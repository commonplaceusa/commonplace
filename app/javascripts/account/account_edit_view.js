var AccountEditView = CommonPlace.View.extend({
  template: "account.edit",
  id: "account-edit",
  
  events: {
    "submit": "editAccount",
    "click .avatar a.delete": "deleteAvatar"
  },
  
  initialize: function(options) {
    this.account = options.account;
    this.community = options.community;
    this.interests = options.interests;
    this.skills = options.skills;
    this.goods = options.goods;
  },
  
  afterRender: function() {
    this.$(".about").autoResize();
    
    var get_posts = this.account.get("neighborhood_posts");
    this.$("[name=get-posts][value='" + get_posts + "']").attr("checked", "checked");
    
    this.populateSelected(this.account.get("interests"), this.$("[name=interests]"));
    this.populateSelected(this.account.get("skills"), this.$("[name=skills]"));
    this.populateSelected(this.account.get("goods"), this.$("[name=goods]"));
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
    
    this.account.save(changes, {
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
  
  fullName: function() { return this.account.get("name"); },
  
  about: function() { return this.account.get("about"); },
  
  email: function() { return this.account.get("email"); },
  
  avatarUrl: function() { return this.account.get("avatar_url"); },
  
  interests: function() { return this.interests; },
  
  skills: function() { return this.skills; },
  
  goods: function() { return this.goods; },

  initAvatarUploader: function($el) {
    var self = this;
    var uploader = new AjaxUpload($el, {
      action: "/api" + self.account.link("avatar"),
      name: 'avatar',
      data: { },
      responseType: 'json',
      onChange: function(file, extension){},
      onSubmit: function(file, extension) {},
      onComplete: function(file, response) { 
        self.account.set(response); 
        self.render();
      }
    });    
  },

  deleteAvatar: function(e) {
    var self = this;
    if (e) { e.preventDefault(); }
    this.account.deleteAvatar(function() {
      self.render();
    });
  }
});

