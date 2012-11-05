
OrganizerApp.Charts = CommonPlace.View.extend({

  template: "organizer_app.statistics-charts",

  events: {
     "click #set-date":"setStartdate",
     "click #graphs":"drawVisualization"
  },

  initialize: function() {
    community=this.options.community;
  },

  afterRender:function () {
    /*$(this.el).html('<div id="set-start-date" style="display:none">Organize start date is not set. Set now?<input id="start-date" type="text" placeholder="Date (MM/DD/YYYY)"><button id="set-start-date">Set</button></div><br><select id="graphs"><option value="user">User Amount</option></select><br><div id="chart_div"></div>');*/
    //$(this.el).html('<div id="set-start-date" style="display:none">Organize start date is not set. Set now?</div><br>Users Amount<div id="users_div"></div>Posts Amount<div id="posts_div"></div>Events Amount<div id="events_div"></div>Feeds Amount<div id="feeds_div"></div>');
    this.$('#set-start-date').append('<input id="start-date" type="text" placeholder="Date (DD/MM/YYYY)" />');
    this.$('#set-start-date').append('<button id="set-date">Set</button>');
    if(!this.options.community.get('organize_start_date')){
      this.$("#set-start-date").get(0).style.display="";
    }

    this.showCharts();

    google.load('visualization', '1',  {'callback':this.drawVisualization,
      'packages':['corechart']});

    return this;
  },

  showCharts: function() {
    var url = '/api/communities/'+community.id+'/user_charts';

    $.get(url, _.bind(function(stats) {

      this.drawCharts(stats);
    }, this));
  },

  drawCharts: function(data) {
    this.$("#charts").append(
      _.map(data, _.bind(function(table) {
        var tb = $("<table border='1'/>");

        tb.append(
          _.map(table, _.bind(function(row) {
            var tr = $("<tr/>");

            tr.append(
              _.map(row, _.bind(function(cell) {
                var td = $("<td/>", { text: cell })[0];

                return td;
              }, this)));

            return tr[0];
          }, this)));

        return tb[0];
      }, this)));
  },

  drawVisualization: function () {
    var data = new google.visualization.DataTable();
    var url = '/api/communities/'+this.community.id+'/user_stats';

    $.get(url, function(stats) {
      users = google.visualization.arrayToDataTable(stats['users'], false);
      posts = google.visualization.arrayToDataTable(stats['posts'], false);
      events = google.visualization.arrayToDataTable(stats['events'], false);
      leaders = google.visualization.arrayToDataTable(stats['leaders'], false);
      leaders_p = google.visualization.arrayToDataTable(stats['leaders_p'], false);
      neighbors = google.visualization.arrayToDataTable(stats['neighbors'], false);
      neighbors_p = google.visualization.arrayToDataTable(stats['neighbors_p'], false);
      adopters = google.visualization.arrayToDataTable(stats['adopters'], false);
      adopters_p = google.visualization.arrayToDataTable(stats['adopters_p'], false);

      var options = {
        chartArea:{left:35,top:10,width:"90%",height:"60%"},
        vAxis: {0:{title: "Amount",logScale: false},1:{}},
        hAxis: {title: "Day",textPosition: "out",textStyle:{fontSize: 10}},
        series: {0:{type: "line",targetAxisIndex:1},1: {type: "bars",targetAxisIndex:0}},
        legend: {position: 'in',textStyle: {color: 'blue', fontSize: 12}}
      };
      var userschart = new google.visualization.ComboChart($('#users_div').get(0));
      var postschart = new google.visualization.ComboChart($('#posts_div').get(0));
      var eventschart = new google.visualization.ComboChart($('#events_div').get(0));
      var leaderschart = new google.visualization.ComboChart($('#leaders_div').get(0));
      var leaders_pchart = new google.visualization.ComboChart($('#leaders_p_div').get(0));
      var neighborschart = new google.visualization.ComboChart($('#neighbors_div').get(0));
      var neighbors_pchart = new google.visualization.ComboChart($('#neighbors_p_div').get(0));
      var adopterschart = new google.visualization.ComboChart($('#adopters_div').get(0));
      var adopters_pchart = new google.visualization.ComboChart($('#adopters_p_div').get(0));

      google.visualization.events.addListener(userschart, 'select', this.selectHandler);

      userschart.draw(users, options);
      postschart.draw(posts, options);
      eventschart.draw(events, options);
      leaderschart.draw(leaders, options);
      leaders_pchart.draw(leaders_p, options);
      neighborschart.draw(neighbors, options);
      neighbors_pchart.draw(neighbors_p, options);
      adopterschart.draw(adopters, options);
      adopters_pchart.draw(adopters_p, options);

    });
  },

  selectHandler: function () {
    var selectedItem = chart.getSelection()[0];
    if (selectedItem) {
      var value = data.getValue(selectedItem.row, selectedItem.column);
      alert('The user selected ' + value);
    }
  },

  setStartdate: function(){
    var date=$('#start-date').val();
    data={organize_start_date: date};
    editdiv=this.$("#set-start-date").get(0);
    $.ajax({
      type: 'POST',
      contentType: "application/json",
      url: this.options.community.url(),
      data: JSON.stringify(data),
      cache: 'false',
      success: function() {
        alert("Saved!");
        editdiv.style.display="none";
        location.reload();
      }
    });
  }
});
