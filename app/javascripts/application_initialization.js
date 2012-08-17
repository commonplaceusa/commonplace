
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
    xfbml  : true,
    channelUrl: "//www.ourcommonplace.com/channel"
  });
  fbApiInit = true;
}

$(function() {

  var communitySlug = window.location.pathname.split("/")[1];

  $("body").delegate("a[data-remote]", "click", function(e) {
    e.preventDefault();
    var fragment = e.currentTarget.pathname;
    Backbone.history.navigate(fragment, true);
  });

  var getCommunity = $.getJSON("/api/communities/" + communitySlug,
                               function(r) {

                                 CommonPlace.community = new Community(r);
                               });

  var getAccount = $.getJSON("/api/account", function(r) {
    CommonPlace.account = new Account(r);
  });

  $.when(getAccount, getCommunity).then(function() {
    window.app = new Application();

    (new FeatureSwitching({
      account: CommonPlace.account,
      el: $("#feature-switching")})
    ).render();

    Backbone.history.start({ pushState: Modernizr.history });
  });

  (function() {
    var e = document.createElement('script');
    e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
    e.async = true;
    document.getElementById('fb-root').appendChild(e);
  }());
});
