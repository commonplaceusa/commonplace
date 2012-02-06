
var StatsPage = CommonPlace.View.extend({
  template: "stats_page/main",

  events: {
    /*"click .controls button": "editAccount",
    "click .avatar a.delete": "deleteAvatar"*/
    "click li.header": "toggleDisplay"
  },

  statistics: {},

  initialize: function() {
    this.model = CommonPlace.account;
  },

  toggleDisplay: function(e) {
    var selector = "#" + $(e.target).attr("data-hider");
    console.log("Toggling " + selector);
    $(selector).toggle();
  },

  loadStatistics: function() {
    var self = this;
    $.ajax({
      type: "GET",
      dataType: "json",
      url: "/api/stats/",
      success: function(response) {
        self.populateStatistics(response);
      },
      failure: function(response) {
        self.showError("Could not load statistics: " + response);
      }
    });
  },
  
  afterRender: function() {
    this.loadStatistics();
  },
  
  populateStatistics: function(json_data) {
    console.log(json_data);
    this.statistics = json_data;

    console.log("Loading counts");

    for (community in this.statistics) {
      var slug = this.statistics[community][0];
      var community_stats = _.last(JSON.parse(this.statistics[community][1]), 30);
      console.log("Got for community " + slug);
      console.log(community_stats);
      var first_date = Date.parse(community_stats[0].Date);

      $("#user_count").append("<div class='user_count_graph' id='user_count_graph_" + slug + "'></div>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'user_count_graph_' + slug

        },
        title: {
          text: 'All-Time User Count for ' + slug
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
        },
        tooltip: {
          enabled: true
        },
        legend: {
          enabled: true
        },

        series: [{
          name: 'Users',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.UsersTotal); })
        }, /*{
          name: 'Daily Bulletin Opens',
          pointIntercal: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.DailyBulletinOpensToday); })
        },*/ {
          name: 'Users Active over Past 30 Days',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.UsersActiveOverPast30Days); })
        }, {
          name: 'Users Logged In over Past 3 Months',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.UsersLoggedInOverPast3Months); })
        }, {
          name: 'Users Posting over Past 3 Months',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.UsersPostingOverPast3Months); })
        }]
      });
    }

    console.log("Loading growth");
    for (community in this.statistics) {
      var slug = this.statistics[community][0];
      var community_stats = _.last(JSON.parse(this.statistics[community][1]), 30);
      var first_date = Date.parse(community_stats[0].Date);

      $("#user_gains").append("<div class='user_growth_graph' id='user_growth_graph_" + slug + "'></div>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'user_growth_graph_' + slug

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
        yAxis: {
          title: {
            text: 'Users'
          },
        },
        tooltip: {
          enabled: true
        },
        legend: {
          enabled: false
        },

        series: [{
          name: 'Users',
          pointInterval: 24*3600*1000,
          pointStart: first_date,
          data: _.map(community_stats, function(stat) { return parseInt(stat.UsersGainedDaily); })
        }]
      });
    }
    /*
    for (community in this.statistics) {
      var slug = this.statistics[community][0];
      var community_stats = JSON.parse(this.statistics[community][1]);
      var first_date = Date.parse(community_stats[0].Date);

      $("#content_posting").append("<div class='content_posting_graph' id='content_posting_graph_" + slug + "'></div>");

      new Highcharts.Chart({
        chart: {
          renderTo: 'content_posting_graph_' + slug,
          defaultSeriesType: 'column'

        },
        title: {
          text: 'Posted Content for ' + slug
        },
        xAxis: {
          title: {
            text: 'Content'
          }
        },
        yAxis: {
          title: {
            text: 'Total Content'
          },
          stackLabels: {
            enabled: true
          }
        },
        tooltip: {
          enabled: true
        },
        legend: {
          enabled: false
        },
        plotOptions: {
          column: {
            stacking: 'normal',
            dataLabels: {
              enabled: true,
              color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
            }
          }
        },

        series: [{
          name: 'Posts',
          data: _.map(community_stats, function(stat) { return parseInt(stat.PostsTotal); })
        }, {
          name: 'Events',
          data: _.map(community_stats, function(stat) { return parseInt(stat.EventsTotal); })
        }, {
          name: 'Group Posts',
          data: _.map(community_stats, function(stat) { return parseInt(stat.GroupPostsTotal); })
        }, {
          name: 'Announcements',
          data: _.map(community_stats, function(stat) { return parseInt(stat.AnnouncementsTotal); })
        }, {
          name: 'Private Messages',
          data: _.map(community_stats, function(stat) { return parseInt(stat.PrivateMessagesTotal); })
        }
        ]
      });
    }*/
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
