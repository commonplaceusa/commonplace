CommonPlace.registration.ApplyCivicLeaderForm = CommonPlace.View.extend(
  template: "registration.apply_civic_leader"
  events:
    "click button.next-button": "submit"

  initialize: ->
    @data = {}

  submit: (e) ->
    e.preventDefault()  if e
    self = this
    _.each ["name", "email", "application_reason"], (data_point) ->
      self.data[data_point] = self.$("[name=" + data_point + "]").val()

    post_api = "/api" + @options.communityExterior.links.registration.apply_civic_leader
    $.post post_api, @data, _.bind((response) ->
      new CommonPlace.registration.ApplicationOrNominationSubmittedView(
        el: $(@options.el)
        applying_or_nominating: "applying"
      ).render()
    , this)
)
