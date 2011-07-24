
CommonPlace.SaySomething = Backbone.View.extend({
  tagName: "div",
  id: "say-something",
  
  events: {
    "submit form.post": "submitPost",
    "submit form.announcement": "submitAnnouncement",
    "submit form.event": "submitEvent",
    "submit form.group_post": "submitGroupPost"
  },
  
  render: function() {
    var view = this[this.template]();
    view[this.template] = true ;
    $(this.el).html(CommonPlace.render(this.template, view));
    $("input.date").datepicker({dateFormat: 'yy-mm-dd'});
  },

  submitPost: function(e) {
    e.preventDefault();
    $("input.create").replaceWith("<img src=\"/images/loading.gif\">");
    if (!this.$("input#commercial").is(':checked')) {
      if (CommonPlace.env == 'production') {
        mpmetrics.track('Submitted Neighborhood Post');
        mpmetrics.track('Submitted Content', {'type': 'neighborhood_post'});
      }
      CommonPlace.community.posts.create({
        title: $("input#post_subject").val(),
        body: $("textarea#post_body").val()
      }, { success: function() {
          window.location.hash = "/posts/new";
          Backbone.history.checkUrl();
          window.location.hash = "/posts";
          Backbone.history.checkUrl();
        }
      });
    } else {
        if (CommonPlace.env == 'production') {
          mpmetrics.track('Submitted Announcement');
          mpmetrics.track('Submitted Content', {'type': 'announcement'});
        }
        CommonPlace.app.notify("Your post is more appropriate as an announcement. We are moving it for you.");
      CommonPlace.community.announcements.create({
          title: $("input#post_subject").val(),
            body: $("textarea#post_body").val(),
            feed: null
        }, { success: function() {
            window.location.hash = "/announcements";
            Backbone.history.checkUrl();
            window.location.hash = "/announcements/new";
            Backbone.history.checkUrl();
        } });
    }
  },

  submitAnnouncement: function(e) {
    e.preventDefault();
    this.$("input.create").replaceWith("<img src=\"/images/loading.gif\">");
    owner_match = this.$("select#announcement_owner").val().match(/([a-z_]+)_(\d+)/);
    if (CommonPlace.env == 'production') {
        mpmetrics.track('Submitted Announcement');
        mpmetrics.track('Submitted Content', {'type': 'announcement'});
    }
    CommonPlace.community.announcements.create({
      title: this.$("input#announcement_subject").val(),
      body: this.$("textarea#announcement_body").val(),
      feed: owner_match[1] == "feed" ? owner_match[2] : null
    }, { success: function() {
      window.location.hash = "/announcements";
      Backbone.history.checkUrl();
      window.location.hash = "/announcements/new";
      Backbone.history.checkUrl();
    } });
  },

  submitEvent: function(e) {
    e.preventDefault();
    this.$("input.create").replaceWith("<img src=\"/images/loading.gif\">");
    owner_match = this.$("select#event_owner").val().match(/([a-z_]+)_(\d+)/);
    if (CommonPlace.env == 'production') {
      mpmetrics.track('Submitted Event');
      mpmetrics.track('Submitted Content', {'type': 'event'});
    }
    CommonPlace.community.events.create({
      title: this.$("input#event_name").val(),
      about: this.$("textarea#event_description").val(),
      date: this.$("input#event_date").val(),
      start: this.$("select#event_start_time").val(),
      end: this.$("select#event_end_time").val(),
      venue: this.$("input#event_venue").val(),
      address: this.$("input#event_address").val(),
      tags: this.$("input#event_tag_list").val(),
      feed: owner_match[1] == "feed" ? owner_match[2] : null
    }, { success: function() {
      window.location.hash = "/events/new";
      Backbone.history.checkUrl();
      window.location.hash = "/events";
      Backbone.history.checkUrl();
    } });
  },

  submitGroupPost: function(e) {
    e.preventDefault();
    this.$("input.create").replaceWith("<img src=\"/images/loading.gif\">");
    if (CommonPlace.env == 'production') {
      mpmetrics.track('Submitted Group Post');
      mpmetrics.track('Submitted Content', {'type': 'group_post'});
    }
    CommonPlace.community.group_posts.create({
      title: this.$("input#group_post_subject").val(),
      body: this.$("textarea#group_post_body").val(),
      group: this.$("select#group_post_group_id").val()
    }, { success: function() {
      window.location.hash = "/group_posts";
      Backbone.history.checkUrl();
      window.location.hash = "/group_posts/new";
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


