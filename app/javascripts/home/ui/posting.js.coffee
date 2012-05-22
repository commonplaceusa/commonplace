Home.ui.Posting = Framework.View.extend
  template: "home.posting"

  render: ->
    this.$el.html this.renderTemplate()

  show: (klass) ->
    this.$(".help, .form-container, .links").hide()
    this.$("." + klass).show()
    this.$(".help." + klass + ".rounded_corners").hide()
    this.$(".links-" + klass).show()
    this.$(".links ." + klass).addClass "current"

  showDefault: (klass) ->
    this.$(".help, .form-container").hide()
    this.$("." + klass).show()
    this.$(".links ." + klass).addClass "current"

