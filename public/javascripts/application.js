
function selectTab(tab) {
  $(document).ready(function(){
    $('header #' + tab).addClass('selected_nav');
  });
};

function setInfoBox() {
   $.getJSON(this.path.slice(1), function(response) {
     $("#info").html(response.info_box);
  });
} 

function setList() {
  $.getJSON(this.path.slice(1), function(response) {
    $("#list").html(response.list);
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
        $('#both_columns ul').prepend(response.createdPost);
      } else {
        alert("post validation failed");
      }
    }, "json");
  });
  
  this.post("/posts/:post_id/replies", function() {
    var $post = $("#post_" + this.params['post_id']);
    var sammy = this;
    
    $.post(this.path, this.params, function(response) {
      $("form.new_reply", $post).replaceWith(response.newReply);
      $("form.new_reply textarea", $post).goodlabel();
      if (response.success) {
        $(".replies ol", $post).append(response.createdReply);
      } else {
        alert("reply validation failed");
      }
    }, "json");
  });

  this.get("#/posts/new", setModal);
  this.get("#/announcements/new", setModal);
  this.get("#/events/new", setModal);
  this.get("#/organizations/new", setModal);
  this.get("#/invites/new", setModal);

  this.get("#/posts/:id", setInfoBox);
  this.get("#/events/:id", setInfoBox);
  this.get("#/announcements/:id", setInfoBox);
  
  this.get("#/announcements", setList);
  this.get("#/events", setList);
  this.get("#/", setList);
  this.get("#/users", setList);
  this.get("#/organizations", setList);
  this.get("#/posts", setList);

});

$(function(){
  app.run();
  
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
  
  $('.filter').tipsy({ gravity: 's', delayOut: 0 });
 
});
