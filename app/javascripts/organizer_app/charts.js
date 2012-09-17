
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
    google.load('visualization', '1',  {'callback':this.drawVisualization,
      'packages':['corechart']});
    return this;
  },

  drawVisualization:function () {
    var data = new google.visualization.DataTable();
    var url = '/api/communities/'+this.community.id+'/user_stats';

    $.get(url, function(stats) {
      users = google.visualization.arrayToDataTable(stats['users'],false);
      posts = google.visualization.arrayToDataTable(stats['posts'],false);
      events = google.visualization.arrayToDataTable(stats['events'],false);
      phone = google.visualization.arrayToDataTable(stats['phone'],false);
      nominees = google.visualization.arrayToDataTable(stats['nominees'],false);
      nominators = google.visualization.arrayToDataTable(stats['nominators'],false);
      posted = google.visualization.arrayToDataTable(stats['posted'],false);
      c_status = google.visualization.arrayToDataTable(stats['c_status'],false);


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
      var phonechart = new google.visualization.ComboChart($('#phone_div').get(0));
      var nomineeschart = new google.visualization.ComboChart($('#nominees_div').get(0));
      var nominatorschart = new google.visualization.ComboChart($('#nominators_div').get(0));
      var postedchart = new google.visualization.ComboChart($('#posted_div').get(0));
      var c_statuschart = new google.visualization.ComboChart($('#c_status_div').get(0));


      google.visualization.events.addListener(userschart, 'select', this.selectHandler);

      userschart.draw(users, options);
      postschart.draw(posts, options);
      eventschart.draw(events, options);
      phonechart.draw(phone, options);
      nomineeschart.draw(nominees, options);
      nominatorschart.draw(nominators, options);
      postedchart.draw(posted, options);
      c_statuschart.draw(c_status, options);

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
