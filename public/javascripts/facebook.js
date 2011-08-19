function fbEnsureInit(callback) {
    if(!window.fbApiInit) {
        setTimeout(function() {fbEnsureInit(callback);}, 50);
    } else {
        if(callback) {
            callback();
        }
    }
}

function facebook_pass(session) {
    console.log("Facebook pass: " + session.uid);
    return session.uid;
}

function facebook_share() {
  u=location.href;
  t=document.title;
  window.open('http://www.facebook.com/sharer.php?u='+encodeURIComponent(u)+'&t='+encodeURIComponent(t),'sharer','toolbar=0,status=0,width=626,height=436');
  return false;
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

