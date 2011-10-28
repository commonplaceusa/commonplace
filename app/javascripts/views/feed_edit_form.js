var FeedEditFormView = FormView.extend({
  template: "shared/feed-edit-form",

  afterRender: function() {
    this.modal.render();
    var kind = this.model.get("kind");
    this.$("[name=kind] [value="+kind+"]").attr("selected", "selected");
    this.$("select.kind_list").dropkick();
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
    return this.model.get("rss_url");
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
  }
});


