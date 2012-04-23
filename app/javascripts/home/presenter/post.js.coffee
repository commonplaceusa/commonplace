class Home.presenter.Post

  constructor: (@post) ->


  toJSON: ->
    _.extend(@post.toJSON(),
      wireCategoryClass: "sports"
      wireCategoryName: "Food & Dining"
      timeAgo: timeAgoInWords(@post.get("published_at")))



