$.fn.submitAjax = (options) ->
  #todo: can this be replaced with jquery ujs?
  params = {
    data: this.serialize()
    # note: for PUT and DELETE methods, rails puts out a _method input, which is not read by this.
    type: this.attr('method') || 'post'
    url: this.attr 'action'
  }
  $.extend(params, options)
  $.ajax(params)

$.fn.fieldHelp = (text) ->
  this.addClass('fieldHelp')
  $tooltip = $("<div class='fieldhelp-tooltip'>#{text}</div>")
  $control = $('<div class="fieldhelp-control">?</div>')
             .appendTo(this.closest('li'))
             .append($tooltip)
             .hover((event) ->
               $tooltip.show()
             , (event) ->
               $tooltip.hide()
             )

$.fn.nextInDom = (selector) ->
 # selector should match both objects
 $group = $(selector)
 $group.eq( $group.index(this) + 1 )


spinners = {
  spaceSpinner: {
    # this is a large space filling spinner
    lines: 12
    length: 10
    width: 2
    radius: 12
    color: '#000'
    speed: 0.9
    trail: 100
    shadow: false
  }
  inputSpinner: {
    # this is a small spinner that fits in an input field
    lines: 8
    length: 4
    width: 1
    radius: 3
    color: '#000'
    speed: 1.1
    trail: 100
    shadow: false
  }
}

$.fn.addSpinner = (type_or_options) ->
  unless Spinner
    console.warn "spin.js must to be included"
    return this

  options = if toString.call(type_or_options) == '[object String]'
              spinners[type_or_options]
            else
              type_or_options

  unless options
    console.warn "invalid spinner parameters: #{options}"
    return this

  $spinner = $("<div class='spinner'></div>").appendTo(this)
  new Spinner(options).spin($spinner.get(0))
  this

$.fn.removeSpinner = () ->
  this.find('.spinner').remove().end()



# <div style="overflow-x: hidden; width: 200px; height: 200px;">
#  <div class="slider">
#    <div>
#      Panel one
#    </div>
#     <div>
#      panel two
#    </div>
#  </div>
#</div>
#.slider {
#  width: 700px;
#  text-align: left; }
#
#.slider > div {
#  display: inline-block;
#  vertical-align: top;
#  text-align: center;
#  width: 200px;
#  min-height: 180px; }
$.fn.slideIn = (duration, easing, complete) ->
  unless this.length > 0
    console.error 'error: undefined slide target'
    console.trace()
    return this

  $slider = this.closest('.slider')
  unless $slider.length > 0
    console.log 'error: not a slider'
    console.trace('not a slider')
    return false

  # prevent tab. be sure to enable before submission if necessary.
  $slider.disable()
  this.enable()

  margin = this.offset().left - $slider.offset().left
  $slider.animate({marginLeft: "-#{margin}px"}, duration, easing, complete)


$.fn.disable = () ->
 #todo: recursive
 this.addClass 'disabled'
 if this.is "input"
   this.attr('disabled', 'disabled')
 else
   x = this.find('input, button, textarea').attr('disabled', 'disabled').end()

$.fn.enable = () ->
  #todo: recursive
  this.removeClass 'disabled'
  if this.is "input"
    this.removeAttr 'disabled'
  else
    this.find('input, button, textarea').removeAttr('disabled').end()
