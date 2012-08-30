CommonPlace.main.RulesView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.rules"
  events:
    "click .next-button": "submit"

  afterRender: ->
    unless @current
      @fadeIn @el
      @current = true

  community_name: ->
    @community.get("name")

  submit: (e) ->
    e.preventDefault()  if e
    window.location.pathname = "/" + @community.get("slug")
)
