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
            url: "/api/accounts/" + CommonPlace.account.get("id") + "/update_avatar_and_fb_auth",
            data: JSON.stringify({
              fb_username: response.username,
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
