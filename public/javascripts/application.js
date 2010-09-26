
function setInfoBoxPosition() {
  if ($(window).scrollTop() + 10 > $('#info').offset().top){
    $('.info_box').css('position','fixed');
  } else {
    $('.info_box').css('position', 'static');
  }
}

function selectTab(tab) {
  $(document).ready(function(){
    $('header #' + tab).addClass('selected_nav');
  });
};

function setInfoBox() {
  
  $.getJSON(this.path.slice(1), function(response) {
    $("#info").html(response.info_box);
    setInfoBoxPosition();
    renderMaps();
  });
} 

function setList() {
  $.getJSON(this.path.slice(1), function(response) {
    $("#list").html(response.list);
    $("#add").replaceWith(response.add);
    $("#info").html(response.info);
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
                  $(this).replaceWith(response.more_info)
                    .show('slide', function () {
                      renderMaps();
                    });
                 });
        $('header').replaceWith(response.header);
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
    
  this.get("#/organizations/:id/claim/new", setModal);
  this.get("#/organizations/:id/claim/edit", setModal);
  this.get("#/organizations/:id/claim/edit_fields", setModal);
  

  this.post("/organizations/:organization_id/claim", function () {
    var context = this;
    $.post(this.path, this.params, function (response) {
      if (response.success) {
        $.modal.close();
        app.location_proxy.setLocation("#/organizations/" + context.params.organization_id + "/claim/edit");
      }
    }, "json");
  });
  
  this.put("/organizations/:organization_id/claim", function () {
    var context = this;
        $.modal.close();
        app.location_proxy.setLocation("#/organizations/" + context.params.organization_id + "/claim/edit_fields");

  });

  this.get("/management/organizations/:organization_id/profile_fields/new", function() {
    var context = this;
    $.getJSON(this.path, function(response) {
      $("#edit_profile_fields #modules").append(response.form);
    });
  });


  this.get("#/organizations/:id/claim/new", setModal);
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
  this.get("", renderMaps);
  this.get("#/users", setList);
  this.get("#/organizations", setList);
  this.get("#/posts", setList);

});

$(function(){
  app.run();
  window.onscroll = setInfoBoxPosition;
  
  $('ul#wire').accordion({'header': 'a.item_body', 
                          'active': false,
                          'collapsible': true, 
                          'autoHeight': false,
                         });

  $('body').click(function(e) {
    if (e.pageX < (($('body').width() - $('#wrap').width()) / 2)) {
      history.back();
    }
  });
  
  $('a[data-nohistory]').live('click', function(e) {
    e.preventDefault();
    app.runRoute("get",$(this).attr('href'));
  });
});
