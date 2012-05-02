

var FeedActionsView = CommonPlace.View.extend({
  id: "feed-actions",
  template: "feed_page/feed-actions",
  events: {
    "click #feed-action-nav a": "navigate",
    "click .post-announcement button": "postAnnouncement",
    "click .post-event button": "postEvent",
    "click .invite-subscribers form.invite-by-email button": "inviteByEmail",
    "change .post-label-selector input": "toggleCheckboxLIClass"
  },

  initialize: function(options) {
    this.feed = options.feed;
    this.groups = options.groups;
    this.account = options.account;
    this.community = options.community;
    this.postAnnouncementClass = "current";
  },
  
  afterRender: function() {
    this.$("input.date").datepicker({dateFormat: 'yy-mm-dd'});
    this.$('input[placeholder], textarea[placeholder]').placeholder();
    //this.$("textarea").autoResize();
    this.$("select.time").dropkick();
  },

  navigate: function(e) {
    var $target = $(e.target);
    $target.addClass("current").siblings().removeClass("current");
    $(this.el).children(".tab")
      .removeClass("current")
      .filter("." + $target.attr('href').split("#")[1].slice(1))
      .addClass("current");
    this.$(".error").hide();
    e.preventDefault();
  },

  toggleCheckboxLIClass: function(e) {
    $(e.target).closest("li").toggleClass("checked");
  },

  showError: function(response) {
    this.$(".error").text(response.responseText);
    this.$(".error").show();
  },

  postAnnouncement: function(e) {
    var $form = this.$(".post-announcement form");
    var self = this;
    this.cleanUpPlaceholders();
    e.preventDefault();
    this.feed.announcements.create(
      { title: $("[name=title]", $form).val(),
        body: $("[name=body]", $form).val(),
        groups: $("[name=groups]:checked", $form).map(function() { return $(this).val(); }).toArray()
      }, {
        success: function() { self.render(); },
        error: function(attribs, response) { self.showError(response); }
      });
  },

  postEvent: function(e) {
    var self = this;
    var $form = this.$(".post-event form");
    e.preventDefault();
    this.cleanUpPlaceholders();
    this.feed.events.create(
      { title:   $("[name=title]", $form).val(),
        about:   $("[name=about]", $form).val(),
        date:    $("[name=date]", $form).val(),
        start:   $("[name=start]", $form).val(),
        end:     $("[name=end]", $form).val(),
        venue:   $("[name=venue]", $form).val(),
        address: $("[name=address]", $form).val(),
        tags:    $("[name=tags]", $form).val(),
        groups:  $("[name=groups]:checked", $form).map(function() { return $(this).val(); }).toArray()
      }, {
        success: function() { self.render(); },
        error: function(attribs, response) { self.showError(response); }
      });
  },

  avatarUrl: function() { return this.feed.get('links').avatar.thumb; },


  time_values: _.flatten(_.map(["AM", "PM"],
                               function(half) {
                                 return  _.map([12,1,2,3,4,5,6,7,8,9,10,11],
                                               function(hour) {
                                                 return _.map(["00", "30"],
                                                              function(minute) {
                                                                return String(hour) + ":" + minute + " " + half;
                                                              });
                                               });
                               })),

  inviteByEmail: function(e) {
    var self = this;
    var $form = this.$(".invite-subscribers form");
    e.preventDefault();
        $.ajax({
          contentType: "application/json",
          url: "/api" + this.feed.link('invites'),
          data: JSON.stringify({ emails: _.map($("[name=emails]", $form).val().split(/,|;/), 
                                               function(s) { return s.replace(/\s*/,""); }),
                                 message: $("[name=message]", $form).val()
                               }),
          type: "post",
          dataType: "json",
          success: function() { self.render(); }});
  }

});
