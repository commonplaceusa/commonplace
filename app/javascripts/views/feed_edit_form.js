var FeedEditFormView = FormView.extend({
  template: "shared/feed-edit-form",
  
  events: {
    "click .cancel": "exit",
    "click .close": "exit",
    "click .delete": "deleteFeed",
    "click .avatar-controls .crop": "cropAvatar",
    "click .avatar-controls .remove": "removeAvatar",
    "click .controls button": "send"
  },

  afterRender: function() {
    this.modal.render();
    var kind = this.model.get("kind");
    this.$("[name=kind] [value="+kind+"]").attr("selected", "selected");
    this.$("select.kind_list").dropkick();
    this.initAvatarUploader(this.$(".avatar .upload"));
  },

  save: function(callback) {
    var self = this;
    this.model.save({
      name: this.$("[name=name]").val(),
      about: this.$("[name=about]").val(),
      kind: this.$("[name=kind]").val(),
      slug: this.$("[name=slug]").val(),
      rss: this.$("[name=rss]").val(),
      website: this.$("[name=website]").val(),
      phone: this.$("[name=phone]").val(),
      address: this.$("[name=address]").val()
    }, {
      success: function() {
        callback();
        window.location.pathname = self.model.get("url");
      },
      error: function(attribs, response) { self.showError(response); }
    });
  },

  showError: function(response) {
    this.$(".error").text(response.responseText);
    this.$(".error").show();
  },

  deleteFeed: function(e) {
    if (e) { e.preventDefault(); }
    this.model.destroy({
      success: _.bind(function() {
        this.updateAccount(function() {
          window.Header.render();
        });
      }
      , this)
    });
    this.exit();
    return app.navigate("/", true);
  },

  feedName: function() {
    return this.model.get("name");
  },

  about: function() {
    return this.model.get("about");
  },

  address: function() {
    return this.model.get("address");
  },
  
  rss: function() {
    return this.model.get("rss");
  },
  
  website: function() {
    return this.model.get("website");
  },
  
  phone: function() {
    return this.model.get("phone");
  },
  
  slug: function() {
    return this.model.get("slug");
  },
  
  deleteUrl: function() {
    return this.model.get("delete_url");
  },
  
  avatarUrl: function() {
    return this.model.link("avatar").thumb;
  },
  
  editUrl: function() {
    return this.model.link("edit");
  },
  
  avatarEditUrl: function() { return this.model.link("avatar_edit"); },
  
  initAvatarUploader: function($el) {
    var self = this;
    var uploader = new AjaxUpload($el, {
      action: "/api" + self.model.link("avatar_edit"),
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
  
  cropAvatar: function(e) {
    if (e) { e.preventDefault(); }
    this.exit();
    var formview = new AvatarCropFormView({
      model: this.model
    });
    formview.render();
  },

  removeAvatar: function(e) {
    var self = this;
    e && e.preventDefault();
    this.model.deleteAvatar(function() {
      self.render();
    });
  }
});


