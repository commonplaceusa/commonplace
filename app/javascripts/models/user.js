
var User = Model.extend({});

var Users = Collection.extend({
  model: User,

  search: function(query) {
    this.uri = "/search/community/1/users?query=" + query;
  }
});
