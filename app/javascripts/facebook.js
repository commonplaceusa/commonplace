function fbEnsureInit(callback) {
    if(!window.fbApiInit) {
        setTimeout(function() {fbEnsureInit(callback);}, 50);
    } else {
        if(callback) {
            callback();
        }
    }
}

function facebook_connect_post_registration() {
  // Pulls an avatar and access token
  fbEnsureInit(function() {
    FB.login(function(response) {
      if (response.authResponse) {
        FB.api("/me", function(response) {
          // Do something with the data
          console.log(response);
          var avatar_url = 'https://graph.facebook.com/' + response.username + '/picture';
          // Set the avatar in the API
          // Store the offline access token via the API
        });
      }
    }, { scope: 'read_friendlists,offline_access' });
  });
}
