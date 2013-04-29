CommonPlace.main.NeighborsView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.neighbors"
  events:
    "click .next-button": "submit"

  afterRender: ->
    @fadeIn @el
    @$('input[placeholder], textarea[placeholder]').placeholder()

  submit: (e) ->
    e.preventDefault()  if e
    @finish()

  finish: ->
    window.location.pathname = "/" + CommonPlace.community.get("slug")
)
