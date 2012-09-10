
OrganizerApp.Charts = CommonPlace.View.extend({

  //template: "organizer_app.statistics-charts",

  events: {
     "click #set-date":"setStartdate",
     "click #graphs":"drawVisualization"
  },

  initialize: function() {
    community=this.options.community;
    //console.log(this.options.community.url());
    /*if(!this.options.community.get('organize_start_date')){
      this.$("#set-start-date").style.display="";
    }*/
  },

  render:function () {
    /*$(this.el).html('<div id="set-start-date" style="display:none">Organize start date is not set. Set now?<input id="start-date" type="text" placeholder="Date (MM/DD/YYYY)"><button id="set-start-date">Set</button></div><br><select id="graphs"><option value="user">User Amount</option></select><br><div id="chart_div"></div>');*/
    $(this.el).html('<div id="set-start-date" style="display:none">Organize start date is not set. Set now?</div><br>Users Amount<div id="users_div"></div>Posts Amount<div id="posts_div"></div>Events Amount<div id="events_div"></div>Feeds Amount<div id="feeds_div"></div>');
    this.$('#set-start-date').append('<input id="start-date" type="text" placeholder="Date (DD/MM/YYYY)" />');
    this.$('#set-start-date').append('<button id="set-date">Set</button>');
    /*
       var newOptions = {
       '':'',
       'users':'User Amount',
       'posts':'Post Amount',
       'emails':'Emails Sent Amount',
       'calls':'Phone Call Amount',
       'profiles':'CH profiles Amount',
       'civicheroes':'Added to CH List',
       'feeds':'Feeds Created',
       'boxes':'Leader Boxes Sent',
       'blurb':'Blurb Sent Out'
       }
       if(this.$('#graphs').prop) {
       var options = this.$('#graphs').prop('options');
       }
       else {
       var options = this.$('#graphs').attr('options');
       }
       $.each(newOptions, function(val, text) {
       options[options.length] = new Option(text, val);
       });*/
    if(!this.options.community.get('organize_start_date')){
      this.$("#set-start-date").get(0).style.display="";
    }
    google.load('visualization', '1',  {'callback':this.drawVisualization,
      'packages':['corechart']});
    return this;
  },

  drawVisualization:function () {
    //console.log("In draw visualization");
    var data = new google.visualization.DataTable();
    //var stats = community.get('user_statistics');
    //console.log(stats);

    var url = '/api/communities/'+this.community.id+'/user_stats';

    $.get(url, function(stats) {
      users = google.visualization.arrayToDataTable(stats['users'],false);
      posts = google.visualization.arrayToDataTable(stats['posts'],false);
      events = google.visualization.arrayToDataTable(stats['events'],false);
      feeds = google.visualization.arrayToDataTable(stats['feeds'],false);

      var options = {
        chartArea:{left:35,top:10,width:"90%",height:"60%"},
      //title : 'User Amount Gain Statistics',
      vAxis: {0:{title: "Amount",logScale: false},1:{}},
      hAxis: {title: "Day",textPosition: "out",textStyle:{fontSize: 10}},
      series: {0:{type: "line",targetAxisIndex:0},1: {type: "bars",targetAxisIndex:1}},
      legend: {position: 'in',textStyle: {color: 'blue', fontSize: 12}}
      };
      var userschart = new google.visualization.ComboChart($('#users_div').get(0));
      var postschart = new google.visualization.ComboChart($('#posts_div').get(0));
      var eventschart = new google.visualization.ComboChart($('#events_div').get(0));
      var feedschart = new google.visualization.ComboChart($('#feeds_div').get(0));

      google.visualization.events.addListener(userschart, 'select', this.selectHandler);

      userschart.draw(users, options);
      postschart.draw(posts, options);
      eventschart.draw(events, options);
      feedschart.draw(feeds, options);
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
    //alert(date);
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
