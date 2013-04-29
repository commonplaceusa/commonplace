CommonPlace.shared.HeaderWrongTown = CommonPlace.View.extend(
  template: "shared.new_header.header-wrong-town"
  id: "choose_town_container"
  className: "choose_town_container"
  tagName: "ul"
  events:
    "click #wrong_town": "toggleTown"

  afterRender: ->
    @$("#choose_town").hide()
    @$("input[placeholder]").placeholder()
    town_list_api = "/api/communities/marquette/comm_completions"
    $.getJSON town_list_api, _.bind((response) ->
      if response
        @$("#town_list").append("<li><a href='/#{town.slug}'>#{town.name}, #{town.state}</a></li>") for town in response
    , this)

  toggleTown: (e) ->
    e.preventDefault()  if e
    @$("#choose_town").toggle()

  create_error: (text) ->
    "<li class='error'>" + text + "</li>"
)
