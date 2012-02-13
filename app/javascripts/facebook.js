function fbEnsureInit(callback) {
    if(!window.fbApiInit) {
        setTimeout(function() {fbEnsureInit(callback);}, 50);
    } else {
        if(callback) {
            callback();
        }
    }
}

function facebook_connect_post_registration(success, failure) {
  // Pulls an avatar and access token
  fbEnsureInit(function() {
    FB.login(function(response) {
      if (response.authResponse) {
        var auth_token = response.authResponse.accessToken;
        FB.api("/me", function(response) {
          // Set the avatar in the API
          // Store the offline access token via the API
          $.ajax({
            type: "POST",
            dataType: "json",
            url: "/api/account/facebook",
            data: JSON.stringify({
              fb_uid: response.id,
              fb_auth_token: auth_token
            }),
            success: function() {
              success();
            },
            failure: function() {
              failure();
            }
          });
        });
      }
    }, { scope: 'read_friendlists,offline_access' });
  });
}

function facebook_connect_registration(options) {
  fbEnsureInit(function() {
    FB.login(function(loginResponse) {
      if (loginResponse.authResponse) {
        var auth_token = loginResponse.authResponse.accessToken;
        FB.api("/me", function(response) {
          var data = {
            full_name: response.name,
            fb_auth_token: auth_token,
            fb_uid: response.id,
            email: response.email
          }
          options.success(data);
        });
      }
    }, { scope: "read_friendlists,offline_access" });
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
