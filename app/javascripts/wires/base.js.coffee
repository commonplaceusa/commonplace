# how do classes and extension work? take a look at:
# http://stackoverflow.com/questions/7735133/backbone-inheratance
# http://jashkenas.github.com/coffee-script/ -- section on classes

# todo on this class
# dry emptymessage (use only noun & share)
# make modelToView more intuitive, dry object creation
# hold all data upon pagination
# go over options, make them dryer, create a Coffee View class that can be extendable anywhere
# make events dom-centric
# look for ways to remove rendering logic, or at least separate from template population methods
# upgrade to handlebars.js -- should be faster and allow better code.

class window.Wire extends CommonPlace.View
  constructor: (options) ->
    @options = options # todo: can we upgrade this syntax?
    # DRY
    # todo: move account to a global CommonPlace.account variable.
    #  then: remove from wire options, including modelToView
    #  then: make modelToView simply a class that gets passed in as an option

    @scope['limit'] = @perPage()
    @scope['page'] = 0


    Backbone.View.apply(this, [options])
    # this is the backbone initialization.  created cid, default option magic, the element, and the events.
    # todo- can we use proto chain to call this, instead?

    # todo: see if we can remove these:
    @emptyMessage = options.emptyMessage
    @modelToView = options.modelToView

    $(this.el).bind 'search', (eventType, eventData) =>
      @search(eventData['query'])


  template: "wires/wire"

  aroundRender: (render) ->
    @collection.fetch({
      data: @scope
      success: render
    })

  afterRender: () ->
    $ul = this.$("ul.wire-list")
    this.collection.each (model) =>
      $ul.append(@modelToView(model).render().el)

  scope: {}

  query: () ->
    # todo: where is this used?
    (@scope['query'] || '')


  perPage: () ->
    (@options.perPage || @_defaultPerPage)

  allFetched: () ->
    # this is a hack so that we can easily share a template with paginating wire
    true

  isEmpty: () ->
    @collection.isEmpty()

  emptyMessage: () ->
    @options.emptyMessage;

  search: (query) ->
    @scope['query'] = query
    @render()

  isSearchEnabled: () ->
    # todo: move this in to a global helper w/ help of handlerbars
    # http://yehudakatz.com/2010/09/09/announcing-handlebars-js/
#    @isActive('wireSearch')
    true
