CommonPlace.main.RulesView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.rules"
  events:
    "click .next-button": "submit"

  afterRender: ->
    @hideSpinner()
    unless @current
      @fadeIn @el
      @current = true

  submit: (e) ->
    e.preventDefault()  if e
    window.location = window.location.protocol + "//" + window.location.host + "/" + CommonPlace.community.get("slug") #performing the redirect this way ensures it works with IE and the hash routing
)
