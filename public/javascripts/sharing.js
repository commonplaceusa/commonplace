function share(url, name, description, name, community)
{
  var header = name + " Posted an Event to " + community + "'s CommonPlace";
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