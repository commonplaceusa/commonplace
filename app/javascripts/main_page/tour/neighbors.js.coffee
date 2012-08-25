CommonPlace.main.NeighborsView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.neighbors"
  events:
    "click .next-button": "submit"

  afterRender: ->
    @slideIn @el

  community_name: ->
    @community.get("name")

  submit: (e) ->
    e.preventDefault()  if e
    @finish()

  finish: ->
    window.location.pathname = "/" + @community.get("slug")
)
