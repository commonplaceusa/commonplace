Home.model.Community = Backbone.Model.extend
  url: ->
    "/api/communities/" + this.get("slug")


  getNeighbors: (params) ->
    neighbors = new Backbone.Collection()
    neighbors.url = "/api" + this.get("links").users
    neighbors.fetch params

