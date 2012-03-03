
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
    this.statistics = json_data;

    $("#user_count").append(this.liHiderFor('user_count_graph_cumulative', 'Cumulative User Count'));
    $("#user_count").append("<li class='graph full global user_count_graph' id='user_count_graph_cumulative'></li>");
    var c = new Highcharts.Chart({
      chart: {
        renderTo: 'user_count_graph_cumulative',
        defaultSeriesType: 'column'
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

      plotOptions: {
         area: {
            pointStart: first_date
         },
         column: {
           stacking: 'normal',
           dataLabels: {
             enabled: false
           }
         }
      },
      tooltip: { enabled: true },
      legend: { enabled: true },
      series: _.map(_.reject(this.statistics, function(raw_stat) { return raw_stat[0] == "global"; }), function(raw_stats) {
        var slug = raw_stats[0];
        var statistics = _.last(JSON.parse(raw_stats[1]), 30);
        var first_date = Date.parse(statistics[0].Date);
        var options = {
          name: slug,
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(statistics, function(stat) { return Number(stat.UsersTotal); })
        };
        return options;
      }),
      credits: { enabled: true }
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
          name: 'Users Engaging over Past 3 Months',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.UsersActiveOverPast30Days) / Number(stat.UsersTotal) * 100; })
        }, {
          name: 'Users Logged In over Past 3 Months',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.UsersLoggedInOverPast3Months) / Number(stat.UsersTotal) * 100; })
        }, {
          name: 'Users Posting over Past 3 Months',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.UsersPostingOverPast3Months) / Number(stat.UsersTotal) * 100; })
        }, {
          name: 'Daily Bulletins Opened',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.NeighborhoodPostEmailsOpenedToday) / Number(stat.UsersTotal) * 100; })
        }],
        credits: { enabled: false }
      });

    }

    for (community in this.statistics) {
      slug = this.statistics[community][0];
      community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days);
      first_date = Date.parse(community_stats[0].Date);

      $("#daily_network_engagement").append(this.liHiderFor("daily_network_engagement_graph_" + slug, slug));
      $("#daily_network_engagement").append("<li class='graph full " + slug + " daily_network_engagement_graph' id='daily_network_engagement_graph_" + slug + "'></li>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'daily_network_engagement_graph_' + slug
        },
        title: {
          text: 'Daily Network Engagement'
        },
        xAxis: {
          type: 'datetime',
          title: {
            text: null
          }
        },
        yAxis: {
          title: {
            text: 'Percentage'
          },
          min: 0,
          max: 100
        },
        tooltip: {
          enabled: true
        },
        legend: {
          enabled: true
        },
        series: [{
          name: 'Percentage of Users who Opened Daily Bulletin',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.DailyBulletinsOpenedToday) / Number(stat.UsersTotal); })
        }, {
          name: 'Percentage of Users who Opened Post Email',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.NeighborhoodPostEmailsOpenedToday) / Number(stat.UsersTotal); })
        }, {
          name: 'Percentage of Users who Visited Platform',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersVisitedToday) / Number(stat.UsersTotal); })
        }, {
          name: 'Percentage of Users who Adjusted Something',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: []
        }, {
          name: 'Percentage of Users who Posted/Replied/Messaged',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: []
        }, {
          name: 'Percentage of Users who did anything',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: []
        }],
        credits: { enabled: false }
      });
    }

    for (community in this.statistics) {
      slug = this.statistics[community][0];
      community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days);
      first_date = Date.parse(community_stats[0].Date);

      $("#network_engagement").append(this.liHiderFor("network_engagement_graph_" + slug, slug));
      $("#network_engagement").append("<li class='graph full " + slug + " network_engagement_graph' id='network_engagement_graph_" + slug + "'></li>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'network_engagement_graph_' + slug
        },
        title: {
          text: 'Network Engagement'
        },
        xAxis: {
          type: 'datetime',
          title: {
            text: null
          }
        },
        yAxis: {
          title: {
            text: 'Percentage'
          },
          min: 0,
          max: 100
        },
        tooltip: {
          enabled: true
        },
        legend: {
          enabled: true
        },
        series: [{
          name: 'Percentage of Neighbors who Visited Site',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersVisitedToday) / Number(stat.UsersTotal); })
        }, {
          name: 'Percentage of Neighbors who Visited Site in Past Week',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersVisitedInPastWeek) / Number(stat.UsersTotal); })
        }, {
          name: 'Percentage of Neighbors who Visited Site in Past Month',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersVisitedInPastMonth) / Number(stat.UsersTotal); })
        }],
        credits: { enabled: false }
      });
    }

    for (community in this.statistics) {
      slug = this.statistics[community][0];
      community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days);
      first_date = Date.parse(community_stats[0].Date);

      $("#levels_of_engagement").append(this.liHiderFor("levels_of_engagement_graph_" + slug, slug));
      $("#levels_of_engagement").append("<li class='graph full " + slug + " levels_of_engagement_graph' id='levels_of_engagement_graph_" + slug + "'></li>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'levels_of_engagement_graph_' + slug,
          defaultSeriesType: 'column'
        },
        title: {
          text: 'Levels of Engagement'
        },
        xAxis: {
          type: 'datetime',
          title: {
            text: null
          }
        },
        yAxis: {
          title: {
            text: 'Percentage'
          },
          min: 0,
          max: 100
        },
        tooltip: {
          enabled: true
        },
        legend: {
          enabled: true
        },
        series: [{
          name: 'Visited 0 Times in Past Week',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.UsersTotal) - Number(stat.UsersReturnedOnceInPastWeek) - Number(stat.UsersReturnedTwiceInPastWeek) - Number(stat.UsersReturnedThreeOrMoreTimesInPastWeek); })
        }, {
          name: 'Visited 1 Time in Past Week',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.UsersReturnedOnceInPastWeek); })
        }, {
          name: 'Visited 2 Times in Past Week',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.UsersReturnedTwiceInPastWeek); })
        }, {
          name: 'Visited 3+ Times in Past Week',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.UsersReturnedThreeOrMoreTimesInPastWeek); })
        }],
        credits: { enabled: false }
      });
    }

    community = 0;
    slug = this.statistics[community][0];
    community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days);
    first_date = Date.parse(community_stats[0].Date);

    $("#user_gains").append(this.liHiderFor("user_growth_graph_" + slug, slug));
    $("#user_gains").append("<li class='graph full " + slug + " user_growth_graph' id='user_growth_graph_" + slug + "'></li>");

    new Highcharts.Chart({
      chart: {
        renderTo: 'user_growth_graph_' + slug,
        defaultSeriesType: 'column'
      },
      title: {
        text: 'Users Gained for ' + slug
      },
      xAxis: {
        type: 'datetime',
        title: {
          text: null
        }
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

      plotOptions: {
         area: {
            pointStart: first_date
         },
         column: {
           stacking: 'normal',
           dataLabels: {
             enabled: false
           }
         }
      },
      tooltip: {
        enabled: true
      },
      legend: {
        enabled: false
      },

      series: _.map(_.reject(this.statistics, function(raw_stat) { return raw_stat[0] == "global"; }), function(raw_stats) {
        var slug = raw_stats[0];
        console.log("Working with " + slug);
        var statistics = _.last(JSON.parse(raw_stats[1]), 30);
        var first_date = Date.parse(statistics[0].Date);
        var options = {
          name: slug,
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(statistics, function(stat) { return Number(stat.UsersGainedDaily); })
        };
        console.log(_.map(statistics, function(stat) { return Number(stat.UsersGainedDaily); }));
        return options;
      }),
      credits: { enabled: false }
    });

    for (community in this.statistics) {
      slug = this.statistics[community][0];
      community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days);
      first_date = Date.parse(community_stats[0].Date);

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
           //labels: {
           //   formatter: function() {
           //     return null;
           //   }
           //}
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
               enabled: false
             }
           }
        },

        series: [{
           name: 'Posts',
           data: _.map(community_stats, function(stat) { return Number(stat.PostsToday); })
        }, {
           name: 'Events',
           data: _.map(community_stats, function(stat) { return Number(stat.EventsToday); })
        }, {
           name: 'Group Posts',
           data: _.map(community_stats, function(stat) { return Number(stat.GroupPostsToday); })
        }, {
           name: 'Announcements',
           data: _.map(community_stats, function(stat) { return Number(stat.AnnouncementsToday); })
        }, {
          name: 'Private Messages',
          data: _.map(community_stats, function(stat) { return Number(stat.PrivateMessagesToday); })
        }],
        credits: { enabled: false }
      });
    }

    for (community in this.statistics) {
      slug = this.statistics[community][0];
      community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days);
      first_date = Date.parse(community_stats[0].Date);

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
          data: _.map(community_stats, function(stat) { return Number(stat.FeedAnnouncementsToday); })
        }, {
          name: 'Feed Events Today',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.FeedEventsToday); })
        }, {
          name: 'Feeds Posting Today',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.FeedsPostingToday); })
        }],
        credits: { enabled: false }
      });
    }

    for (community in this.statistics) {
      slug = this.statistics[community][0];
      community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days / 2);
      first_date = Date.parse(community_stats[0].Date);

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
          data: _.map(community_stats, function(stat) { return Number(stat.PctgFeedsEdited); })
        }, {
          name: 'Pctg of Feeds Streaming',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.PctgFeedsStreaming); })
        }, {
          name: 'Pctg of Feeds who Posted an Event',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.PctgFeedsPostedEvent); })
        }, {
          name: 'Pctg of Feeds who Posted an Announcement',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.PctgFeedsPostedAnnouncement); })
        }],
        credits: { enabled: false }
      });
    }

    for (community in this.statistics) {
      slug = this.statistics[community][0];
      community_stats = _.last(JSON.parse(this.statistics[community][1]), 14);
      first_date = Date.parse(community_stats[0].Date);

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
              enabled: false
            }
          }
        },
        series: [{
          name: 'Posts No Reply',
          data: _.map(community_stats, function(stat) { return Number(stat.PostsToday) - Number(stat.PostsRepliedToToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'posts'
        }, {
          name: 'Posts Replied To',
          data: _.map(community_stats, function(stat) { return Number(stat.PostsRepliedToToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'posts'
        }, {
          name: 'Events No Reply',
          data: _.map(community_stats, function(stat) { return Number(stat.EventsToday) - Number(stat.EventsRepliedToToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'events'
        }, {
          name: 'Events Replied To',
          data: _.map(community_stats, function(stat) { return Number(stat.EventsRepliedToToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'events'
        }, {
          name: 'Anouncements No Reply',
          data: _.map(community_stats, function(stat) { return Number(stat.AnnouncementsToday) - Number(stat.AnnouncementsRepliedToToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'announcements'
        }, {
          name: 'Announcements Replied To',
          data: _.map(community_stats, function(stat) { return Number(stat.AnnouncementsRepliedToToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'announcements'
        }, {
          name: 'GroupPosts No Reply',
          data: _.map(community_stats, function(stat) { return Number(stat.GroupPostsToday) - Number(stat.GroupPostsRepliedToToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'group_posts'
        }, {
          name: 'GroupPosts Replied To',
          data: _.map(community_stats, function(stat) { return Number(stat.GroupPostsRepliedToToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'group_posts'
        }],
        credits: { enabled: false }
      });
    }


    for (community in this.statistics) {
      slug = this.statistics[community][0];
      community_stats = _.last(JSON.parse(this.statistics[community][1]), 7);
      first_date = Date.parse(community_stats[0].Date);

      $("#email_opens").append("<li class='graph full " + slug + " email_opens_graph' id='email_opens_graph_" + slug + "'></li>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'email_opens_graph_' + slug,
          defaultSeriesType: 'column'
        },
        title: {
          text: 'Email Statistics for ' + slug
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
              enabled: false
            }
          }
        },
        series: [{
          name: 'Post Unopened',
          data: _.map(community_stats, function(stat) { return Number(stat.NeighborhoodPostEmailsSentToday) - Number(stat.NeighborhoodPostEmailsOpenedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'posts'
        }, {
          name: 'Post Opened',
          data: _.map(community_stats, function(stat) { return Number(stat.NeighborhoodPostEmailsOpenedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'posts'
        }, {
          name: 'Daily Bulletin Unopened',
          data: _.map(community_stats, function(stat) { return Number(stat.DailyBulletinsSentToday) - Number(stat.DailyBulletinsOpenedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'daily_bulletin'
        }, {
          name: 'Daily Bulletin Opened',
          data: _.map(community_stats, function(stat) { return Number(stat.DailyBulletinsOpenedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'daily_bulletin'
        }, {
          name: 'Group Post Unopened',
          data: _.map(community_stats, function(stat) { return Number(stat.GroupPostEmailsSentToday) - Number(stat.GroupPostEmailsOpenedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'group_posts'
        }, {
          name: 'Group Post Opened',
          data: _.map(community_stats, function(stat) { return Number(stat.GroupPostEmailsOpenedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'group_posts'
        }, {
          name: 'Announcement Unopened',
          data: _.map(community_stats, function(stat) { return Number(stat.AnnouncementEmailsSentToday) - Number(stat.AnnouncementEmailsOpenedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'announcements'
        }, {
          name: 'Announcement Opened',
          data: _.map(community_stats, function(stat) { return Number(stat.AnnouncementEmailsOpenedToday); }),
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          stack: 'announcements'
        }],
        credits: { enabled: false }
      });
    }

    for (community in this.statistics) {
      slug = this.statistics[community][0];
      community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days);
      first_date = Date.parse(community_stats[0].Date);

      $("#user_historical_engagement").append(this.liHiderFor("user_historical_engagement_graph_" + slug, slug));
      $("#user_historical_engagement").append("<li class='graph full " + slug + " user_historical_engagement_graph' id='user_historical_engagement_graph_" + slug + "'></li>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'user_historical_engagement_graph_' + slug
        },
        title: {
          text: 'User Historical Engagement for ' + slug
        },
        xAxis: {
          type: 'datetime',
          title: {
            text: null
          }
        },
        yAxis: {
          min: 0,
          max: 100
        },
        tooltip: {
          enabled: true
        },
        legend: {
          enabled: true
        },
        series: [{
          name: 'User Added Data',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersAddedDataPast6Months) / Number(stat.UsersTotal); })
        }, {
          name: 'Neighborhood Post',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersPostedNeighborhoodPostPast6Months) / Number(stat.UsersTotal); })
        }, {
          name: 'Reply',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersRepliedPast6Months) / Number(stat.UsersTotal); })
        }, {
          name: 'Event',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersPostedEventPast6Months) / Number(stat.UsersTotal); })
        }, {
          name: 'Announcement',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersPostedAnnouncementPast6Months) / Number(stat.UsersTotal); })
        }, {
          name: 'Posted to Group',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersPostedGroupPostPast6Months) / Number(stat.UsersTotal); })
        }, {
          name: 'Private Messaged',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersPrivateMessagedPast6Months) / Number(stat.UsersTotal); })
        }, {
          name: 'Updated Profile',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersUpdatedProfilePast6Months) / Number(stat.UsersTotal); })
        }, {
          name: 'Thanked',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersThankedPast6Months) / Number(stat.UsersTotal); })
        }, {
          name: 'Metted',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return 100 * Number(stat.UsersMettedPast6Months) / Number(stat.UsersTotal); })
        }],
        credits: { enabled: false }
      });
    }

    for (community in this.statistics) {
      slug = this.statistics[community][0];
      community_stats = _.last(JSON.parse(this.statistics[community][1]), this.statistic_days);
      first_date = Date.parse(community_stats[0].Date);

      $("#neighborhood_post_types").append(this.liHiderFor("neighborhood_post_types_graph_" + slug, slug));
      $("#neighborhood_post_types").append("<li class='graph full " + slug + " neighborhood_post_types_graph' id='neighborhood_post_types_graph_" + slug + "'></li>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'neighborhood_post_types_graph_' + slug,
          defaultSeriesType: 'column'
        },
        title: {
          text: 'Neighborhood Post Types for ' + slug
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

        plotOptions: {
          column: {
            stacking: 'normal',
            dataLabels: {
              enabled: false
            }
          }
        },

        series: [{
          name: 'Offers',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.OffersPosted); })
        },{
          name: 'Requests',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.RequestsPosted); })
        },{
          name: 'Meetups',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.MeetUpsPosted); })
        },{
          name: 'Conversations',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return Number(stat.ConversationsPosted); })
        }],
        credits: { enabled: false }
      });

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
  }

});

