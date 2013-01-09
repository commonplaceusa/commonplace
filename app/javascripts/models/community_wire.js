var CommunityWire = Model.extend({
  initialize: function(options) {
    this.uri = "/api" + options.uri;
  },
  
  fetch: function(data, callback) {
    var self = this;
    $.getJSON(this.uri, data, function(response) {
      self.neighborhood = new Posts(response["neighborhood"], CommonPlace.community.categories.neighborhood);
      self.offers = new Posts(response["offers"], CommonPlace.community.categories.offers);
      self.help = new Posts(response["help"], CommonPlace.community.categories.help);
      self.publicity = new PostLikes(response["publicity"], CommonPlace.community.categories.publicity);
      self.other = new Posts(response["other"], CommonPlace.community.other);

      self.groupPosts = new GroupPosts(response["group"], CommonPlace.community.groupPosts);
      self.events = new Events(response["events"], CommonPlace.community.events);
      self.meetups = new Posts(response["meetups"], CommonPlace.community.categories.meetups);
      self.transactions = new Transactions(response["transactions"], CommonPlace.community.transactions);
      if (callback) { callback() };
    });
  },
  
  all: function() { return [
    this.neighborhood, this.offers, this.help, this.publicity, this.other, this.groupPosts, this.events, this.meetups, this.transactions];
  }
});

