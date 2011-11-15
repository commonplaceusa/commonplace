#= require jquery
#= require placeholder
#= require jcrop
#= require chosen
#= require jquery-extensions
#= require jquery.validate
#= require spin



# this code looks broken
#  $("form.crop img").load(function() {
#    $("form.crop").css({ width: Math.max($("#cropbox").width(), 420) });
#  });


window.validators = {} # filled by .validate()
validation_messages = {
  '#step1': {
    'user[full_name]': {
      required: 'Please register with your first and last name'
    }
  }
}

form_initializers = { # takes a selector and returns an initialized .step
  '#step2': (data) ->
    mpq.track 'Password entry', {'community': CommonPlace.community_attrs['slug'] } # track is asynchronous
    this.find('.registrar_name').html(data['first_name']).end()

  '#step3': (data) -> # avatar
    mpq.track 'Cropping Avatar', {'community': CommonPlace.community_attrs['slug'] }
    unless data['avatar']
      return initialize_step '#step4'

    this.find('#cropbox').attr 'src', data['avatar']

    updateCrop = (coords) ->
      $("#crop_x").val coords.x
      $("#crop_y").val coords.y
      $("#crop_w").val coords.w
      $("#crop_h").val coords.h

    $("#cropbox").Jcrop({
      onChange: updateCrop
      onSelect: updateCrop
      aspectRatio: 1.0
    })

    this

  '#step4': (data) -> # feeds
    mpq.track 'Add feeds', {'community': CommonPlace.community_attrs['slug'] }
    return initialize_step '#step5' if $("#feeds_container .feed").length == 0
    this

  '#step5': (data) -> # groups
    mpq.track 'Add groups', {'community': CommonPlace.community_attrs['slug'] }
    if $("#groups_container .group").length == 0
      window.location = '/#tour'
      return false
    this
}

initialize_step = (selector, data) ->
  initializer = form_initializers[selector]
  if initializer
    initializer.call($(selector), data)
  else
    $(selector)

show_step = (selector, data) ->
  $step = initialize_step(selector, data)
  $step.css({display:'inline-block'}).slideIn() if $step


$ () -> # dom ready
  csrfToken = $('meta[name=csrf-token]').attr('content')

  # all pages
  # todo: move somewhere more generic
  $('input[placeholder], textarea[placeholder]').placeholder()

  $('a[data-action=submit]').click (event) ->
    unless $(this).hasClass('disabled')
      $(this).closest('form').submit()
    event.preventDefault() # remove this line if implementing ajax history


  $("[data-chosen]").chosen()


  $("[data-fieldhelp]").each () ->
    $(this).fieldHelp $(this).data('fieldhelp')


  $('#registration_referral_source').change () -> # show next question dropdown
    selection = $("#registration_referral_source option:selected").text()

    new_label = {
      # todo: dry against _step2 erb
      "At a table or booth at an event": "What was the event?"
      "In an email": "Who was the email from?"
      "On Facebook or Twitter": "From what person or organization?"
      "On another website": "What website?"
      "In the news": "From which news source?"
      "Word of mouth": "From what person or organization?"
      "Other": "Where?" }[selection]

    if (new_label)
      $('#registration_referral_metadata_input label').text(new_label)
      $('#registration_referral_metadata_input').show('slow')


  $("<div/>", { id: "file_input_fix" })
    .append($("<input/>", { type: "text", name: "file_fix", id: "file_style_fix" }))
    .append($("<div/>", { id: "browse_button", text: "Browse..." }))
    .appendTo("#registration_avatar_input")


  $('#registration_avatar').change () ->
    $("#file_input_fix input").val($(this).val().replace(/^.*\\/,""))


  $("[data-phauxCheckbox]").each () -> # todo: test
    $checkbox = $("input:checkbox", this);
    $phauxCheckbox = $(this)
    $(this).closest('.label').bind 'click', () ->
      $phauxCheckbox.toggleClass('checked');
      $checkbox.attr "checked", $checkbox.is(":checked") ? false : "checked"


#  hash = window.location.hash
#  if (hash == '#step2')
#    show_step hash, {first_name: 'First name yada'} # todo



#  to ajax-validate email, use either the following code or: http://docs.jquery.com/Plugins/Validation/Methods/remote
#  $('<div id="email_validate_spinner" class="field_spinner"></div>').appendTo("#registration_email_input").hide();
#
#  $('input.email').blur () ->
#    console.log 'email blur'
#
#    $li = $("#registration_email_input")
#    $input = $('#registration_email')
#
#    $("#email_validate_spinner").show()
#    fieldspinner.spin($("#email_validate_spinner").get(0));
#
#    $.ajax {
#       url: '/api/registrations/validate_email'
#       data: {email: $input.val(), csrfToken: csrfToken}
#       dataType: 'text'
#       complete: (data, jqXHR) ->
#         console.log 'ajax done', data, jqXHR
#         if data.responseText == 'available'
#           $input.addClass 'available'
#           $('#email_validate_spinner').addClass('available').html('&#10004;')
#         else
#           $input.addClass 'error'
#           $('#email_validate_spinner').addClass('unavailable').html('&#10008;')
#    }



  # define validation and submission rules:
  $('form.registration').each (index, element) ->
    $form = $(this)
    $button = $form.find('[data-action=submit]')
    current_step_selector = "##{$form.closest('.step').attr('id')}"
    next_step_selector = $button.attr('href')

    validators[current_step_selector] = $form.validate {
      messages: validation_messages["#{current_step_selector}"] || {}

      submitHandler: () ->
        if $form.data('remote1') == 'false'
          return true

        else
          $button.addClass('disabled').addSpinner('inputSpinner')

          $form.submitAjax {
            complete: (textStatus, jqXHR) ->
              $button.removeClass('disabled').removeSpinner()

            success: (data, textStatus, jqXHR) ->
              console.log 'ajax callback', data, jqXHR, textStatus

              if errors = data['errors']
                $.each errors, (key, value) ->
                  errors["registration[#{key}]"] = value[0]
                  delete errors[key]
                try
                  validators[current_step_selector].showErrors(errors)
                catch error
                  # e.g. user.rb validates last_name as well as full_name
                  console.warn "Validation error on nonexistant input"
              else
                show_step(next_step_selector, data)

            error: (jqXHR, textStatus, errorThrown) ->
              console.warn 'error', jqXHR, textStatus, errorThrown
              alert 'There was an error with your request. Please try again later.'
          }
          return false
      }

