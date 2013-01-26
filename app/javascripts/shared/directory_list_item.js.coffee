CommonPlace.shared.DirectoryListItem = CommonPlace.View.extend(
  template: "shared.directory-list-item"
  tagName: "li"

  events:
    "click .directory_item": "clicked_item"

  avatar_url: ->
    @model.get "avatar_url"

  name: ->
    @model.get "name"

  clicked_item: (e) ->
    e.preventDefault() if e
    slug = CommonPlace.community.get("slug")
    schema = @model.get("schema")
    item_id = @model.get("id")
    if schema is "users"
      app.showUserWire(slug, item_id)
      _kmq.push(['record', 'Clicked Directory Neighbor', {"Neighbor": @name}]) if _kmq?
    else if schema is "feeds"
      app.showFeedPage(slug, item_id)
      _kmq.push(['record', 'Clicked Directory Page', {"Page Name": @name}]) if _kmq?
    else if schema is "groups"
      app.showGroupPage(slug, item_id)
      _kmq.push(['record', 'Clicked Directory Page', {"Page Name": @name}]) if _kmq?
)
