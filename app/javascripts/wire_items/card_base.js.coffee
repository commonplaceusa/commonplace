CommonPlace.wire_item.ProfileCard = CommonPlace.View.extend(

  avatar: ->
    @model.get "avatar_url"

  name: ->
    @model.get "name"

  hasAbout: ->
    about = @model.get "about"
    about and about.length > 0

  about: ->
    @model.get "about"

  messageUser: (e) ->
    e.preventDefault() if e
    return @showRegistration() if @isGuest()
    formview = new MessageFormView(model: new Message(messagable: @model))
    formview.render()
)
