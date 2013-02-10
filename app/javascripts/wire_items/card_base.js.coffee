CommonPlace.wire_item.ProfileCard = CommonPlace.View.extend(

  avatar: ->
    @model.get "avatar_url"

  name: ->
    @model.get "name"

  about: ->
    @model.get "about"

  messageUser: (e) ->
    e.preventDefault() if e
    formview = new MessageFormView(model: new Message(messagable: @model))
    formview.render()
)
