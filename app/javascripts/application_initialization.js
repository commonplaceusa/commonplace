
function onABCommComplete() {
  text = "";
  $($("textarea#invite_email").val().split(", "))
    .each(function(index, value) { text += value.replace(/(.*)<(.*)>/, "$2") + ", "; });
  $("textarea#invite_email").val(text.substring(0, text.length-2));
}

function fbAsyncInit() {
  FB.init({
    appId : CommonPlace.facebookAppId,
    status : true,
    cookie : true,
    xfbml  : true
  });
  fbApiInit = true;
}

$(function() {

  window.app = new Application();

  $("body").delegate("a[data-remote=true]", "click", function(e) { 
    e.preventDefault();
    Backbone.history.navigate($(e.target).attr('href').slice(1), true);
  });
  var communitySlug = window.location.pathname.split("/")[1];
  
  var getCommunity = $.getJSON("/api/communities/" + communitySlug, 
                               function(r) {
                                 CommonPlace.community = new Community(r);
                               });

  var getAccount = $.getJSON("/api/account", function(r) {
    CommonPlace.account = new Account(r);
  });

  $.when(getAccount, getCommunity).then(function() {
    Backbone.history.start({ pushState: true });
  });

  (function() {
    var e = document.createElement('script');
    e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
    e.async = true;
    document.getElementById('fb-root').appendChild(e);
  }());
});
