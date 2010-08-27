
function selectTab(tab) {
  $(document).ready(function(){
    $('header #' + tab).addClass('selected_nav');
  });
};

function setInfoBox() {
   $.getJSON(this.path.slice(1), function(response) {
     $("#info").html(response.info_box);
     if (response.map) {
       renderMap(response.map);
     }
  });
} 

function setList() {
  $.getJSON(this.path.slice(1), function(response) {
    $("#list").html(response.list);
    $("#add").replaceWith(response.add);
  });
}

function setModal() {
  $.getJSON(this.path.slice(1), function(response) {
    $(response.form).modal({
      overlayClose: true,
      onClose: function() { 
        $.modal.close(); 
        history.back()
      }
    });
  });
}

var app = $.sammy(function() { 

  this.post("/posts", function() {
    $.post(this.path, this.params, function(response) {
      $("#new_post").replaceWith(response.newPost);
      $("#new_post textarea").goodlabel();
      if (response.success) {
        $('ul#wire').prepend(response.createdPost);
      } else {
        alert("post validation failed");
      }
      $.modal.close();
    }, "json");
  });

  this.post("/replies", function() {
    var sammy = this;
    $item = $(this.target).closest('li');
    $.post(this.path, this.params, function(response) {
      $("form.new_reply", $item).replaceWith(response.newReply);
      $("form.new_reply textarea", $item).goodlabel();
      if (response.success) {
        $(".replies ul", $item).append(response.createdReply);
      } else {
        alert("reply validation failed");
      }
    }, "json");
  });

  
  this.post("/account", function() {
    // Because HTML does not send empty checkboxes, Rails adds a hidden field as
    // default value. This doesn't work when we send all params with javascript,
    // so we collapse the privacy policy value here.
    this.params["user[privacy_policy]"] = this.params["user[privacy_policy]"][1] || 0;
    $.post("/account", this.params, function (response) {
      if (response.success) {
        $('#registration')
          .hide('slide', {}, 500,  
                function(){ 
                  $(this).html(response.more_info)
                    .show('slide');
                });
      } else {
        $('#registration')
          .hide('slide',{}, 500,
                function(){
                  $(this).html(response.form)
                    .show('slide');
                });
      }
    }, "json");
  });
  
  this.get("#/management/organizations/:organization_id/profile_fields/new", setModal);
  
  this.get("#/posts/new", setModal);
  this.get("#/announcements/new", setModal);
  this.get("#/events/new", setModal);
  this.get("#/organizations/new", setModal);
  this.get("#/invites/new", setModal);
  this.get("#/users/:user_id/messages/new", setModal);
  this.get("#/tags/new", setModal);
  this.get("#/posts/:id", setInfoBox);
  this.get("#/events/:id", setInfoBox);
  this.get("#/announcements/:id", setInfoBox);
  this.get("#/users/:id", setInfoBox);
  this.get("#/organizations/:id", setInfoBox);

  this.get("#/tags", setList);
  this.get("#/announcements", setList);
  this.get("#/events", setList);
  this.get("#/", setList);
  this.get("#/users", setList);
  this.get("#/organizations", setList);
  this.get("#/posts", setList);

  this.get("#manage", function () {
    this.redirect(this.params["manage"]);
  });

});

$(function(){
  app.run();
  $("input[name='_method']").each(function() { 
    var method = $(this).val(); 
    $(this).closest('form').attr('method', method); 
  }); 
  $('a[data-remote]').live('click', function(e) {
    app.location_proxy.setLocation("#" + $(this).attr('href'));
    e.preventDefault()
  });
  
  $(document).scroll(function (){
    if ($(window).scrollTop() + 10 > $('#info').offset().top){
      $('#info').addClass('fixed');
    } else {
      $('#info').removeClass('fixed');
    }
  });

  $('textarea').autoResize({animateDuration: 50, extraSpace: 5});
  
   
  $('ul#wire').accordion({'header': 'a.item_body', 
                          'active': false,
                          'collapsible': true, 
                          'autoHeight': false,
                         });
  $('#toggle_map').toggle( function(){
    $('#map').css({
      width: "100%",
      height: "250px",
      "margin-bottom": "10px"
    });
    $("#toggle_map").html("COLLAPSE MAP");
  }, function() {
    $('#map').css({
      width: "200px",
      height: "150px",
      "margin-bottom": "0"
    });
    $("#toggle_map").html("EXPAND MAP / GET DIRECTIONS");
  });
  
  $('#modules').sortable();
  $('#modules').disableSelection();
  
  $('#org_url').textTruncate(140);
  
});

function renderMap(args) {
  var directionsService = new google.maps.DirectionsService(),
      directionsDisplay = new google.maps.DirectionsRenderer({ 
        suppressMarkers: true
      }),
      from = new google.maps.LatLng(args.directions.from.lat, args.directions.from.lng),
      to = new google.maps.LatLng(args.directions.to.lat, args.directions.to.lng),
      myOptions = {
        zoom: 15,
        center: from,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        navigationControl: true,
        mapTypeControl: false,
        scaleControl: true
      },
      map = new google.maps.Map(document.getElementById("map"), myOptions),
      directionsRequest = {
        origin: from,
        destination: to,
        travelMode: google.maps.DirectionsTravelMode.WALKING
      };

  
  directionsDisplay.setMap(map);    
  var fromMarker = new google.maps.Marker({
    position: from, 
    map: map
  });
  var toMarker = new google.maps.Marker({
    position: to,
    map: map
  });

  directionsService.route(directionsRequest, function(result, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(result);
    }
  });

}

