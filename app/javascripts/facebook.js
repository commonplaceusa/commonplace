function fbEnsureInit(callback) {
    if(!window.fbApiInit) {
        setTimeout(function() {fbEnsureInit(callback);}, 50);
    } else {
        if(callback) {
            callback();
        }
    }
}

function fbConnect(api, scope, callback) {
  fbEnsureInit(function() {
    FB.login(function(loginResponse) {
      if (loginResponse.authResponse) {
        var auth_token = loginResponse.authResponse.accessToken;
        FB.api(api, function(response) {
          callback(auth_token, response);
        });
      }
    }, { scope: scope });
  });
}

function facebook_connect_post_registration(success, failure) {
  fbConnect("/me", "read_friendlists,offline_access", function(auth_token, response) {
    $.ajax({
      type: "POST",
      dataType: "json",
      url: "/api/account/facebook",
      data: JSON.stringify({
        fb_uid: response.id,
        fb_auth_token: auth_token
      }),
      success: function() { success(); },
      failure: function() { failure(); }
    });
  });
}

function facebook_connect_registration(options) {
  fbConnect("/me", "offline_access,email", function(auth_token, response) {
    var data = {
      full_name: response.name,
      fb_auth_token: auth_token,
      fb_uid: response.id,
      email: response.email
    };
    FB.api("/me/picture?type=normal", function(avatar_url) {
      data.avatar_url = avatar_url;
      options.success(data);
    });
  });
}

function facebook_connect_avatar(options) {
  fbConnect("/me", "offline_access", function(auth_token, response) {
    var data = {
      fb_auth_token: auth_token,
      fb_uid: response.id
    }
    FB.api("/me/picture?type=normal", function(avatar_url) {
      data.avatar_url = avatar_url;
      options.success(data);
    });
  });
}

function facebook_connect_friends(options) {
  fbConnect("/me/friends", "", function(auth_token, response) {
    var friends = response.data;
    options.success(friends);
  });
}

function facebook_connect_user_picture(options) {
  fbConnect("/" + options.id + "/picture?type=square", "", function(auth_token, response) {
    options.success(response);
  });
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
