CommonPlace.main.EventForm = CommonPlace.main.BaseForm.extend(
  template: "main_page.forms.event-form"
  className: "create-event event"

  afterRender: ->
    @$("input.date", @el).datepicker dateFormat: "yy-mm-dd"
    @$("input[placeholder], textarea[placeholder]").placeholder()
    @hideSpinner()
    
    @$("select.time").dropkick()
    self = this
    @$("input.date").bind "change", ->
      self.onFormBlur target: self.$("input.date")

  createPost: (e) ->
    e.preventDefault()
    @showSpinner()
    @disableSubmitButton()
    self = this
    @cleanUpPlaceholders()
    data =
      title: @$("[name=title]").val()
      about: @$("[name=about]").val()
      date: @$("[name=date]").val()
      start: @$("[name=start]").val()
      end: @$("[name=end]").val()
      venue: @$("[name=venue]").val()
      address: @$("[name=address]").val()
      tags: @$("[name=tags]").val()
      groups: @$("[name=groups]:checked").map(->
        $(this).val()
      ).toArray()
    @sendPost CommonPlace.community.events, data

  groups: ->
    CommonPlace.community.get "groups"

  time_values: _.flatten(_.map(["AM", "PM"], (half) ->
    _.map [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], (hour) ->
      _.map ["00", "30"], (minute) ->
        String(hour) + ":" + minute + " " + half


  ))
)
