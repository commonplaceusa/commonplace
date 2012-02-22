var FindMyNeighborsPage = CommonPlace.View.extend({
  template: "find_my_neighbors_page.main",
  track: true,
  page_name: "find_my_neighbors",

  events: {
    "click input.continue": "submit",
    "submit form": "submit",
    "click a.facebook": "facebook"
  },

  afterRender: function() {
    var self = this;
    this.page = 0;

    this.$(".neighbor_finder").scroll(function() {
      if (($(this).scrollTop() + 10) > (2 * this.scrollHeight / 3)) { self.nextPageThrottled(); }
    });

    this.nextPageTrigger();
    this.nextPageThrottled();
  },

  nextPageTrigger: function() {
    this.nextPageThrottled = _.once(_.bind(function() { this.nextPage(); }, this));
  },

  nextPage: function() {
    $.getJSON(
      "/api" + CommonPlace.community.link("residents"),
      { page: this.page, limit: 100 },
      _.bind(function(response) {

        if (response.length) {
          this.page++;
          var neighbors = [];
          _.each(response, _.bind(function(neighbor) {

            var fbUser = this.getFacebookUser(neighbor.first_name + " " + neighbor.last_name);
            var itemView = new this.NeighborItemView({
              model: neighbor,
              fbUser: fbUser
            });
            (!_.isEmpty(fbUser)) ? neighbors.unshift(itemView) : neighbors.push(itemView);

          }, this));
          this.appendPage(neighbors);
        }

      }, this)
    );
  },

  appendPage: function(neighbors) {
    var $row;
    var $table = this.$("table");
    var $lastRow = $(_.last($table[0].rows));
    if (this.page && $table[0].rows.length && $lastRow[0].cells.length == 1) {
      var itemView = neighbors.shift();
      itemView.render();
      $lastRow.append(itemView.el);
    }

    _.each(neighbors, _.bind(function(itemView, index) {
      itemView.render();

      if (index % 2 === 0) { $row = $($table[0].insertRow(-1)); }
      $row.append(itemView.el);
    }, this));
    this.nextPageTrigger();
  },

  submit: function(e) {
    if (e) { e.preventDefault(); }

    var data = {
      neighbors: _.map(this.$("input[name=neighbors_list]:checked"), function(neighbor) {
        return { name: $(neighbor).val() };
      }),
      can_contact: (this.$("input[name=can_contact]").attr("checked")) ? true : false
    };

    if (data.neighbors.length) {
      $.post("/api" + CommonPlace.account.link("neighbors"), data, _.bind(function() {
        this.finish()
      }, this));
    } else { this.finish(); }
  },

  facebook: function(e) {
    if (e) { e.preventDefault(); }

    facebook_connect_friends({
      success: _.bind(function(friends) {
        this.friends = friends;
        this.$("tr").remove();
        this.page = 0;
        this.nextPageTrigger();
        this.nextPageThrottled();
      }, this)
    });
  },

  getFacebookUser: function(name) {
    return _.find(this.friends, function(friend) {
      return friend.name.toLowerCase() == name.toLowerCase();
    });
  },

  finish: function() {
    // redirect to the community's main page
  },

  NeighborItemView: CommonPlace.View.extend({
    template: "find_my_neighbors_page.neighbor",
    tagName: "td",

    events: { "click": "check" },

    afterRender: function() {
      if (this.isFacebook()) {
        this.check();
        facebook_connect_user_picture({
          id: this.options.fbUser.id,
          success: _.bind(function(url) {
            this.$("img").attr("src", url);
          }, this)
        });
      }
    },

    avatar_url: function() { return "/assets/block.png"; },
    first_name: function() { return this.model.first_name; },
    last_name: function() { return this.model.last_name; },

    isFacebook: function() { return !_.isEmpty(this.options.fbUser); },

    check: function(e) {
      if (e) { e.preventDefault(); }
      var $checkbox = this.$("input[type=checkbox]");
      if ($checkbox.attr("checked")) {
        $checkbox.removeAttr("checked");
      } else { $checkbox.attr("checked", "checked"); }
      $(this.el).toggleClass("checked");
    }
  })
});
