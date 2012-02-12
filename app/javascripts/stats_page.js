
var StatsPage = CommonPlace.View.extend({
  template: "stats_page/main",

  events: {
    "click .header": "toggleDisplay",
    "click .subheader": "toggleDisplay"
  },

  statistics: {},
  statistic_days: 30,

  initialize: function() {
    this.model = CommonPlace.account;
  },

  toggleDisplay: function(e) {
    var selector = "#" + $(e.target).attr("data-hider");
    $(selector).toggle("slow");
  },

  loadStatistics: function() {
    $.blockUI({ message: '<h1>Just a moment...</h1>' });
    var self = this;
    $.ajax({
      type: "GET",
      dataType: "json",
      url: "/api/stats/days",
      success: function(response) {
        self.statistic_days = response;
        $.ajax({
          type: "GET",
          dataType: "json",
          url: "/api/stats/",
          success: function(response) {
            self.populateStatistics(response);
            $(".graph").hide();
            $(".global").show("slow");
            $.unblockUI();
          },
          failure: function(response) {
            self.showError("Could not load statistics: " + response);
          }
        });
      },
      failure: function(response) {
        self.showError("Could not load number of days of statistics");
      }
    });
  },

  afterRender: function() {
    this.loadStatistics();
  },

  liHiderFor: function(id, text) {
    return "<li class='subheader' data-hider='" + id + "'>" + text + "</li>";
  },

  populateStatistics: function(json_data) {
    console.log(json_data);
    this.statistics = json_data;

    $("#user_count").append(this.liHiderFor('user_count_graph_cumulative', 'Cumulative User Count'));
    $("#user_count").append("<li class='graph full global user_count_graph' id='user_count_graph_cumulative'></li>");
    var c = new Highcharts.Chart({
      chart: {
        renderTo: 'user_count_graph_cumulative'
      },
      title: {
        text: 'User Counts across Communities'
      },
      xAxis: {
        type: 'datetime',
        title: {
          text: null
        }
      },
      yAxis: {
        title: {
          text: 'Users'
        },
        min: 0
      },
      tooltip: { enabled: true },
      legend: { enabled: true },
      series: _.map(_.reject(this.statistics, function(raw_stat) { return raw_stat[0] == "global" }), function(raw_stats) {
        var slug = raw_stats[0];
        var statistics = _.last(JSON.parse(raw_stats[1]), 30);
        var first_date = Date.parse(statistics[0].Date);
        var options = {
          name: slug,
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(statistics, function(stat) { return parseInt(stat.UsersTotal); })
        };
        return options;
      })
    });

    for (community in this.statistics) {
      var slug = this.statistics[community][0];
      var community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days);
      var first_date = Date.parse(community_stats[0].Date);

      $("#user_count").append(this.liHiderFor("user_count_graph_" + slug, slug));
      $("#user_count").append("<li class='graph full " + slug + " user_count_graph' id='user_count_graph_" + slug + "'></li>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'user_count_graph_' + slug

        },
        title: {
          text: 'User Count for ' + slug
        },
        xAxis: {
          type: 'datetime',
          title: {
            text: null
          }
        },
        yAxis: {
          title: {
            text: 'Users'
          },
          min: 0,
          max: 100
        },
        tooltip: {
           formatter: function() {
              return ''+
                this.series.name +': '+ this.y +'%';
           }
        },
        legend: {
          enabled: true
        },

        series: [{
          name: 'Users',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100; })
        }, {
          name: 'Users Active over Past 30 Days',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.UsersActiveOverPast30Days) / parseInt(stat.UsersTotal) * 100; })
        }, {
          name: 'Users Logged In over Past 3 Months',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.UsersLoggedInOverPast3Months) / parseInt(stat.UsersTotal) * 100; })
        }, {
          name: 'Users Posting over Past 3 Months',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.UsersPostingOverPast3Months) / parseInt(stat.UsersTotal) * 100; })
        }],
        credits: { enabled: false }
      });
    }

    for (community in this.statistics) {
      var slug = this.statistics[community][0];
      var community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days);
      var first_date = Date.parse(community_stats[0].Date);

      $("#user_gains").append(this.liHiderFor("user_growth_graph_" + slug, slug));
      $("#user_gains").append("<li class='graph full " + slug + " user_growth_graph' id='user_growth_graph_" + slug + "'></li>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'user_growth_graph_' + slug,
          zoomType: 'x',
          defaultSeriesType: 'column'
        },
        title: {
          text: 'Users Gained for ' + slug
        },
        xAxis: {
          categories: _.map(community_stats, function(stat) { return stat.Date } )
        },
        yAxis: {
          title: {
            text: 'Users'
          }
        },
        tooltip: {
          enabled: true
        },
        legend: {
          enabled: false
        },

        series: [{
          name: 'Users Gained',
          data: _.map(community_stats, function(stat) { return parseInt(stat.UsersGainedDaily); })
        }],
        credits: { enabled: false }
      });
    }

    for (community in this.statistics) {
      var slug = this.statistics[community][0];
      var community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days);
      var first_date = Date.parse(community_stats[0].Date);

      $("#content_posting").append(this.liHiderFor("content_posting_graph_" + slug, slug));
      $("#content_posting").append("<li class='graph full " + slug + " content_posting_graph' id='content_posting_graph_" + slug + "'></li>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'content_posting_graph_' + slug,
          defaultSeriesType: 'column'
        },
        title: {
          text: 'Total Posted Content for ' + slug
        },
        xAxis: {
           labels: {
              formatter: function() {
                return null;
              }
           }
        },
        yAxis: {
           title: {
              text: 'Content'
           },
           min: 0
        },
        plotOptions: {
           area: {
              pointStart: first_date
           },
           column: {
             stacking: 'normal',
             dataLabels: {
               enabled: true
             }
           }
        },

        series: [{
           name: 'Posts',
           data: _.map(community_stats, function(stat) { return parseInt(stat.PostsToday); })
        }, {
           name: 'Events',
           data: _.map(community_stats, function(stat) { return parseInt(stat.EventsToday); })
        }, {
           name: 'Group Posts',
           data: _.map(community_stats, function(stat) { return parseInt(stat.GroupPostsToday); })
        }, {
           name: 'Announcements',
           data: _.map(community_stats, function(stat) { return parseInt(stat.AnnouncementsToday); })
        }, {
          name: 'Private Messages',
          data: _.map(community_stats, function(stat) { return parseInt(stat.PrivateMessagesToday); })
        }],
        credits: { enabled: false }
      });
    }

    for (community in this.statistics) {
      var slug = this.statistics[community][0];
      var community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days);
      var first_date = Date.parse(community_stats[0].Date);

      $("#feed_posting").append(this.liHiderFor("feed_posting_graph_" + slug, slug));
      $("#feed_posting").append("<li class='graph full " + slug + " feed_posting_graph' id='feed_posting_graph_" + slug + "'></li>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'feed_posting_graph_' + slug,
          defaultSeriesType: 'column'
        },
        title: {
          text: 'Daily Feed Engagement for ' + slug
        },
        xAxis: {
          type: 'datetime',
          title: {
            text: null
          }
        },
        yAxis: {
          min: 0
        },
        tooltip: {
          enabled: true
        },
        legend: {
          enabled: true
        },

        series: [{
          name: 'Feed Announcements Today',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.FeedAnnouncementsToday); })
        }, {
          name: 'Feed Events Today',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.FeedEventsToday); })
        }, {
          name: 'Feeds Posting Today',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.FeedsPostingToday); })
        }],
        credits: { enabled: false }
      });
    }

    for (community in this.statistics) {
      var slug = this.statistics[community][0];
      var community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days);
      var first_date = Date.parse(community_stats[0].Date);

      $("#feed_engagement").append(this.liHiderFor("feed_engagement_graph_" + slug, slug));
      $("#feed_engagement").append("<li class='graph full " + slug + " feed_engagement_graph' id='feed_engagement_graph_" + slug + "'></li>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'feed_engagement_graph_' + slug,
          defaultSeriesType: 'column'
        },
        title: {
          text: 'Feed Engagement for ' + slug
        },
        xAxis: {
          type: 'datetime',
          title: {
            text: null
          }
        },
        yAxis: {
          min: 0
        },
        tooltip: {
          enabled: true
        },
        legend: {
          enabled: true
        },

        series: [{
          name: 'Pctg of Feeds Edited',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.PctgFeedsEdited); })
        }, {
          name: 'Pctg of Feeds Streaming',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.PctgFeedsStreaming); })
        }, {
          name: 'Pctf of Feeds who Posted an Event',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.PctgFeedsPostedEvent); })
        }, {
          name: 'Pctg of Feeds who Posted an Announcement',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.PctgFeedsPostedAnnouncement); })
        }],
        credits: { enabled: false }
      });
    }

    for (community in this.statistics) {
      var slug = this.statistics[community][0];
      var community_stats = _.last(JSON.parse(this.statistics[community][1]), 14);
      var first_date = Date.parse(community_stats[0].Date);

      $("#replies_to_content").append(this.liHiderFor("replies_to_content_graph_" + slug, slug));
      $("#replies_to_content").append("<li class='graph full " + slug + " replies_to_content_graph' id='replies_to_content_graph_" + slug + "'></li>");

      new Highcharts.Chart({
        chart: {
          renderTo: "replies_to_content_graph_" + slug,
          defaultSeriesType: 'column',
          zoomable: 'x'
        },
        title: {
          text: 'Reply Overview for ' + slug
        },
        xAxis: {
          type: 'datetime'
        },
        yAxis: {
          min: 0
        },
        tooltip: {
         formatter: function() {
            return ''+
                this.series.name +': '+ this.y +' ('+ Math.round(this.percentage) +'%)';
         }
        },
        legend: {
          enabled: true
        },
        plotOptions: {
          column: {
            stacking: 'normal',
            dataLabels: {
              enabled: true
            }
          }
        },
        series: [{
          name: 'Posts Made',
          data: _.map(community_stats, function(stat) { return parseInt(stat.PostsToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'posts'
        }, {
          name: 'Posts Replied To',
          data: _.map(community_stats, function(stat) { return parseInt(stat.PostsRepliedToToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'posts'
        }, {
          name: 'Events Made',
          data: _.map(community_stats, function(stat) { return parseInt(stat.EventsToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'events'
        }, {
          name: 'Events Replied To',
          data: _.map(community_stats, function(stat) { return parseInt(stat.EventsRepliedToToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'events'
        }, {
          name: 'Anouncements Made',
          data: _.map(community_stats, function(stat) { return parseInt(stat.AnnouncementsToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'announcements'
        }, {
          name: 'Announcements Replied To',
          data: _.map(community_stats, function(stat) { return parseInt(stat.AnnouncementsRepliedToToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'announcements'
        }, {
          name: 'GroupPosts Made',
          data: _.map(community_stats, function(stat) { return parseInt(stat.GroupPostsToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'group_posts'
        }, {
          name: 'GroupPosts Replied To',
          data: _.map(community_stats, function(stat) { return parseInt(stat.GroupPostsRepliedToToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'group_posts'
        }],
        credits: { enabled: true }
      });
    }


    for (community in this.statistics) {
      var slug = this.statistics[community][0];
      if (slug != "global") continue;
      var community_stats = _.last(JSON.parse(this.statistics[community][1]), 7);
      var first_date = Date.parse(community_stats[0].Date);

      $("#email_opens").append("<li class='graph full " + slug + " email_opens_graph' id='email_opens_graph_" + slug + "'></li>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'email_opens_graph_' + slug,
          defaultSeriesType: 'column',
          zoomable: 'x'
        },
        title: {
          text: 'Email Statistics for ' + slug
        },
        xAxis: {
          columns: ['Sent', 'Opened'],
          /*labels: {
            formatter: function() {
              
            }
          }*/
          type: 'datetime'
        },
        yAxis: {
          min: 0
        },
        tooltip: {
         formatter: function() {
            return ''+
                this.series.name +': '+ this.y +' ('+ Math.round(this.percentage) +'%)';
         }
      },
      legend: {
          enabled: true
        },

        plotOptions: {
          column: {
            stacking: 'normal',
            dataLabels: {
              enabled: true
            }
          }
        },

        series: [{
          name: 'Posts Sent',
          data: _.map(community_stats, function(stat) { return parseInt(stat.NeighborhoodPostEmailsSentToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'posts'
        }, {
          name: 'Posts Clicked',
          data: _.map(community_stats, function(stat) { return parseInt(stat.NeighborhoodPostEmailsClickedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'posts'
        }, {
          name: 'Posts Opened',
          data: _.map(community_stats, function(stat) { return parseInt(stat.NeighborhoodPostEmailsOpenedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'posts'
        }, {
          name: 'Daily Bulletin Sent',
          data: _.map(community_stats, function(stat) { return parseInt(stat.DailyBulletinsSentToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'daily_bulletin'
        }, {
          name: 'Daily Bulletin Clicks',
          data: _.map(community_stats, function(stat) { return parseInt(stat.DailyBulletinsClickedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'daily_bulletin'
        }, {
          name: 'Daily Bulletin Opened',
          data: _.map(community_stats, function(stat) { return parseInt(stat.DailyBulletinsOpenedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'daily_bulletin'
        }, {
          name: 'Group Posts Sent',
          data: _.map(community_stats, function(stat) { return parseInt(stat.GroupPostEmailsSentToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'group_posts'
        }, {
          name: 'Group Posts Opened',
          data: _.map(community_stats, function(stat) { return parseInt(stat.GroupPostEmailsOpenedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'group_posts'
        }, {
          name: 'Group Posts Clicked',
          data: _.map(community_stats, function(stat) { return parseInt(stat.GroupPostEmailsClickedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'group_posts'
        }, {
          name: 'Announcements Sent',
          data: _.map(community_stats, function(stat) { return parseInt(stat.AnnouncementEmailsSentToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'announcements'
        }, {
          name: 'Announcements Opened',
          data: _.map(community_stats, function(stat) { return parseInt(stat.AnnouncementEmailsOpenedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'announcements'
        }, {
          name: 'Announcements Clicked',
          data: _.map(community_stats, function(stat) { return parseInt(stat.AnnouncementEmailsClickedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'announcements'
        }
        ],
        credits: { enabled: false }
      });
    }

    for (community in this.statistics) {
      var slug = this.statistics[community][0];
      var community_stats = _.last(JSON.parse(this.statistics[community][1]), 30);

      $("#post_content").append("<h2 class='header' data-hider='post_content_list_" + slug + "'>Posts for " + slug + "</h2>")
      $("#post_content").append("<ul class='post_content_list' id='post_content_list_" + slug + "' style='display: none;'></ul>");

      var todays_posts = _.last(community_stats).TodaysPosts.split(";--;");
      _.each(todays_posts, function(post_name) { $("#post_content_list_" + slug).append("<li>" + post_name + "</li>"); });
    }
  },

  showSuccess: function() {
    this.render();
    this.$("select.list").chosen();
    this.$(".success").show();
    this.$(".error").hide();
    $(window).scrollTop(0);
  },

  showError: function(text) {
    this.$(".error").text(text);
    this.$(".error").show();
    this.$(".success").hide();
    $(window).scrollTop(0);
  },

});
