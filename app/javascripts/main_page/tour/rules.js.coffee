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
    window.location = window.location.protocol + "//" + window.location.host + "/" + @community.get("slug") #performing the redirect this way ensures it works with IE and the hash routing
)
