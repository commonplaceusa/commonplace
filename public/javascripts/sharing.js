function share(url, name, description, community)
{
  var header = "CommonPlace - Find Events in " + community;
  FB.login(function(response) {
      if (response.session)
      {
        FB.ui(
        {
          method: 'feed',
            name: header,
            link: url,
	    picture: '',
	    caption: community + ' CommonPlace',
	    description: name + ": " + description,
	    message: 'Message'
        },
        function(response) {
          if (response && response.post_id) {
//            alert('Post was published.');
          } else {
//            alert('Post was not published.');
          }
        }
      );
    }
  });
}