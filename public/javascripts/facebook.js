function fbEnsureInit(callback) {
    if(!window.fbApiInit) {
        console.log("FB Not Initialized");
        setTimeout(function() {fbEnsureInit(callback);}, 50);
    } else {
        console.log("FB initialized");
        if(callback) {
            callback();
        }
    }
}


function facebook_pass(session) {
    return session.uid;
}

function facebook_invite() {
    FB.ui({
        method: 'apprequests',
        message: 'Invitation Text Here',
        data: 'tracking_data'
      });
}

function inviteLoginCallback(fb_message, fb_slug) {
    console.log("Logged in successfully");
    FB.ui({
        method: 'apprequests',
        message: fb_message,
        data: fb_slug,
        display: 'iframe'
    });
}

function invite_friends(fb_message, fb_slug) {
    console.log("Inviting friends...");
    fbEnsureInit(
        function(){
            FB.login(
                function() {
                    inviteLoginCallback(
                        fb_message,
                        fb_slug
                    );
                },
                {perms:'read_stream,publish_stream,offline_access'}
            );
        }
    );
}

