

var FeedActionsView = CommonPlace.View.extend({
  id: "feed-actions",
  template: "feed_page/feed-actions",
  events: {
    "click #feed-action-nav a": "navigate",
    "submit .post-announcement form": "postAnnouncement",
    "submit .post-event form": "postEvent",
    "submit .invite-subscribers form.invite-by-email": "inviteByEmail",
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
    this.$("textarea").autoResize();
  },

  navigate: function(e) {
    var $target = $(e.target);
    $target.addClass("current").siblings().removeClass("current");
    $(this.el).children(".tab").removeClass("current").filter("." + $target.attr('href').slice(2)).addClass("current");
    this.$(".incomplete").hide();
    e.preventDefault();
  },

  toggleCheckboxLIClass: function(e) {
    $(e.target).closest("li").toggleClass("checked");
  },

  incomplete: function(fields) {
    var incompleteFields = fields.shift();
    var self = this;
    _.each(fields, function(f) {
      incompleteFields = incompleteFields + " and " + f;
    });
    this.$(".incomplete-fields").text(incompleteFields);
    this.$(".incomplete").show();
  },

  postAnnouncement: function(e) {
    var $form = $(e.target);
    var self = this;
    this.cleanUpPlaceholders();
    e.preventDefault();
    this.feed.announcements.create(
      { title: $("[name=title]", $form).val(),
        body: $("[name=body]", $form).val(),
        groups: $("[name=groups]:checked", $form).map(function() { return $(this).val(); }).toArray()
      }, {
        success: function() { self.render(); },
        error: function(attribs, response) { self.incomplete(response); }
      });
  },

  postEvent: function(e) {
    var self = this;
    var $form = $(e.target);
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
        error: function(attribs, response) { self.incomplete(response); }
      });
  },

  avatarUrl: function() { return this.feed.get('links').avatar.thumb; },


  time_values: _.flatten(_.map(["AM", "PM"],
                               function(half) {
                                 return  _.map(_.range(1,13),
                                               function(hour) {
                                                 return _.map(["00", "30"],
                                                              function(minute) {
                                                                return String(hour) + ":" + minute + " " + half;
                                                              });
                                               });
                               })),

  inviteByEmail: function(e) {
    var self = this;
    var $form = $(e.target);
    e.preventDefault();
        $.ajax({
          contentType: "application/json",
          url: "/api" + this.feed.links.invites,
          data: JSON.stringify({ emails: _.map($("[name=emails]", $form).val().split(/,|;/), 
                                               function(s) { return s.replace(/\s*/,""); }),
                                 message: $("[name=message]", $form).val()
                               }),
          type: "post",
          dataType: "json",
          success: function() { self.render(); }});
  }

});
