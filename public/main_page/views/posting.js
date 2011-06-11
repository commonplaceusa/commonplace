
CommonPlace.SaySomething = Backbone.View.extend({
  tagName: "div",
  id: "say-something",
  
  events: {
    "submit form.post": "submitPost"
  },
  
  render: function() {
    var view = this[this.template]();
    view[this.template] = true ;
    $(this.el).html(CommonPlace.render(this.template, view));
    $("input.date").datepicker();
  },

  submitPost: function(e) {
    e.preventDefault();
    var self = this;
    var $form = this.$("form");
    $("input.create", $form).replaceWith("<img src=\"/images/loading.gif\">");
    CommonPlace.community.posts.create({ 
      title: $("input#post_subject",$form).val(),
      body: $("textarea#post_body",$form).val() 
    }, { success: function() {
      window.location.hash = "/posts";
      Backbone.history.checkUrl();
      window.location.hash = "/posts/new";
      Backbone.history.checkUrl();
    },
         error: function() { self.render(); }
       });
  },

  submitAnnouncement: function(e) {
    e.preventDefault();
    var $form = this.$("form"),
    owner_match = $("select#announcement_owner", $form).val().match(/([a-z_]+)_(\d+)/);
    
    CommonPlace.community.announcements.create({
      title: $("input#announcement_subject", $form).val(),
      body: $("textarea#announcement_body", $form).val(),
      style: "publicity",
      feed: owner_match[1] == "feed" ? owner_match[2] : null
    }, { success: function() {
      window.location.hash = "/announcements";
      Backbone.history.checkUrl();
      window.location.hash = "/announcements/new";
      Backbone.history.checkUrl();
    } });
  },

  post_form: function() { return ({});},

  event_form: function() { 
    var view = { 
      owners: _(CommonPlace.account.get('accounts')).map(
        function(a) {
          return { name: a.name, value: a.uid };
        })
    };
    view.owners[0].selected = "selected";
    return view;
  },

  announcement_form: function() { 
    var view = { 
      owners: _(CommonPlace.account.get('accounts')).map(
        function(a) {
          return { name: a.name, value: a.uid };
        })
    };
    view.owners[0].selected = "selected";
    return view;
  },

  group_post_form: function() {
    var view = { 
      groups: CommonPlace.community.groups.map(function(g) {
        return { id: g.id, name: g.get('name') };
      })
    };
    view.groups[0].selected = "selected";
    return view;
  }
  
});


