
var StatsWeeklyHealthPage = CommonPlace.View.extend({
  template: "stats_page/weekly_health",

  baseTable: '<table class="health-stats">' +
      '<tr>' +
      ' <th>All</th>' +
      '</tr>' +
      '<tr class="total-users">' +
      '  <th>Total Users</th>' +
      '</tr>' +
      '<tr class="community-growth">' +
      '   <th>Avg. Community Growth</th>' +
      '</tr>' +
      '<tr class="gains-day-community">' +
      '  <th>User Gains/Day/Community</th>' +
      '</tr>' +
      '<tr class="posts-day-community">' +
      '  <th>Posts/Day/Community</th>' +
      '</tr>' +
      '<tr class="daily-bulletin-open-rate">' +
      '  <th>Daily Bulletin Open Rate</th>' +
      '</tr>' +
      '<tr class="weekly-platform-engagement">' +
      '  <th>Weekly Platform Engagement</th>' +
      '</tr>' +
    '</table>',

  afterRender: function() {
    $.ajax({
          type: "GET",
          dataType: "json",
          url: "/api/stats/",
          success: function(response) {
          }
    });
  }
});
