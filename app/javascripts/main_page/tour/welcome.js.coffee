CommonPlace.main.WelcomeView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.welcome"
  events:
    "click .next-button": "submit"

  afterRender: ->
    @fadeIn @el
    @hideSpinner()

  submit: (e) ->
    e.preventDefault()  if e
    @showSpinner()
    @finish()

  finish: ->
    @nextPage "profile", @data
)
