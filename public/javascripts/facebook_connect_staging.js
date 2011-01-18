$(document).ready(function() {
  FB.init({
    appId:102571013152856, cookie:true, 
    status:true, xfbml:true 
  });
});
function userExistsWithFacebookUID(uid)
{
  $.post()
}
function facebookUserWantsToLogIn(user)
{
  FB.api('/me', function(user) { 
    // Send the user to the User Sessions controller to handle the login
    window.location = '/user_sessions/create_from_facebook';
  });
}
function facebookUserLoggedIn(user)
{
  FB.api('/me', function(user) { 
    $('#user_full_name').val(user.name);
    $('#user_email').val(user.email);
    $('#user_facebook_uid').val(user.id);
    $('#user_address').val(user.address.street);
  });
}