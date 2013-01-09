CommonPlace.main.PostForm = CommonPlace.main.BaseForm.extend(
  template: "main_page.forms.post-form"
  className: "create-neighborhood-post post"

  initialize: (options) ->
    CommonPlace.main.BaseForm.prototype.initialize options
    @groups = CommonPlace.community.get("groups")

  createPost: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @showSpinner()
    @disableSubmitButton()
    
    collection = CommonPlace.community.posts
    callback = false

    group_id = @$("[name=group_selector]").val()
    if group_id isnt undefined and group_id isnt ""
      group = new Group({links: {self: "/groups/" + group_id, posts: "/groups/" + group_id + "/posts"}})
      collection = group.posts
      callback = @groupPostSuccess

    data =
      title: @$("[name=title]").val()
      body: @$("[name=body]").val()

    if @category isnt undefined
      data['category'] = @category

    @sendPost collection, data, callback

  groupPostSuccess: ->
    CommonPlace.community.groupPosts.trigger "sync"
)
