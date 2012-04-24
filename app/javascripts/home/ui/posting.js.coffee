Home.ui.Posting = Framework.View.extend
  template: "home.posting"

  render: ->
    this.$el.html this.renderTemplate()
    this.show "conversation"


  show: (klass) ->
    this.$(".help, .form-container").hide()
    this.$("." + klass).show()
    this.$(".links ." + klass).addClass "current"

