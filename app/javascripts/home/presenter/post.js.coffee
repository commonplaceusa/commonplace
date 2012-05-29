class Home.presenter.Post

  constructor: (@post) ->


  toJSON: ->
    _.extend(@post.toJSON(),
      wireCategoryClass: "sports"
      wireCategoryName: this.post.attributes.category
      timeAgo: timeAgoInWords(@post.get("published_at")))



