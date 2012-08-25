CommonPlace.registration.NominateCivicHeroForm = CommonPlace.View.extend(
  template: "registration.nominate_civic_hero"
  events:
    "click button.next-button": "submit"

  initialize: ->
    @data = {}

  submit: (e) ->
    e.preventDefault()  if e
    self = this
    _.each ["nominee_name", "nominee_email", "nomination_reason", "nominator_name", "nominator_email"], (data_point) ->
      self.data[data_point] = self.$("[name=" + data_point + "]").val()

    post_api = "/api" + @options.communityExterior.links.registration.nominate_civic_hero
    $.post post_api, @data, _.bind((response) ->
      new CommonPlace.registration.ApplicationOrNominationSubmittedView(
        el: $(@options.el)
        nominee_name: self.$("[name=nominee_name]").val()
        applying_or_nominating: "nominating"
      ).render()
    , this)

  continue: ->
)
