# currently files are included alphabetically.  This could be changed.
# but perhaps its nice to ensure include order just the same as an IDE view.

class window.WireHeader extends CommonPlace.View


class window.PreviewWire extends window.Wire
  constructor: (options) ->
    super(options)
    @options = options

  _defaultPerPage: 3

  fullWireLink: () ->
    @options.fullWireLink


class window.PaginatingResourceWire extends window.PaginatingWire
  # the usefulness of this class is questionable.
  constructor: (options) ->
      super(options)
  _defaultPerPage: 15


class window.ResourceWire extends window.Wire
  constructor: (options) ->
    super(options)
    @options = options

  usersLinkClass: () ->
    @options.active == 'users' ? 'current' : ''

  feedsLinkClass: () ->
    @options.active == 'feeds' ? 'current' : ''

  groupsLinkClass: () ->
    @options.active == 'groups' ? 'current' : ''