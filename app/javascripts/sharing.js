function share(url, name1, description, name, community) {
  var header = name + " Posted an Event to " + community + "'s CommonPlace";
  FB.login(
    function(response) {
      if (response.session) {
        FB.ui({
          method: 'feed',
          name: header,
          link: url,
	  picture: '',
	  caption: community + ' CommonPlace',
	  description: name + ": " + description,
	  message: 'Message'
        },
              function(response) {});
      }
    });
}