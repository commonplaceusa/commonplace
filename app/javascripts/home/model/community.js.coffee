Home.model.Community = Backbone.Model.extend
  url: ->
    "/api/communities/" + this.get("slug")


  getNeighbors: (params) ->
    neighbors = new Backbone.Collection()
    neighbors.url = "/api" + this.get("links").users
    neighbors.fetch params


  getPosts: (params) ->
    posts = new Backbone.Collection()
    posts.url = "/api" + this.get("links").posts
    posts.fetch params


