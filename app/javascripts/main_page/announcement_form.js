
var AnnouncementForm = CommonPlace.View.extend({
  template: "main_page/announcement-form",
  tagName: "form",
  className: "create-announcement",

  events: {
    "submit": "createAnnouncement",
    "change .post-label-selector input": "toggleCheckboxLIClass"
  },

  afterRender: function() {
    this.$('input[placeholder], textarea[placeholder]').placeholder();
    this.$("textarea").autoResize();
  },

  createAnnouncement: function(e) {
    e.preventDefault();
    this.collection.create({
      title: this.$("[name=title]").val(),
      body: this.$("[name=body]").val(),
      groups: this.$("[name=groups]:checked").map(function() { 
        return $(this).val();
      }).toArray(),
      feed: this.$("[name=feed]").val()
    });
    this.render();
  },

  feeds: function() {
    var owners = this.options.account.get('feeds');
    owners[0].selected = "selected";
    return owners;
  },

  groups: function() {
    return this.options.community.get('groups');
  },

  toggleCheckboxLIClass: function(e) {
    $(e.target).closest("li").toggleClass("checked");
  }

});