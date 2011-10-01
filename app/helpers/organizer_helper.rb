module OrganizerHelper
  def google_api_key()
    if ENV['HEROKU_APP'] == 'commonplace'
      ['ABQIAAAAgdPfd74v_0Ttup6W0tJHtxQB4B98GOFQoxUPdFn0mOBvUSbzOxSwgIAcuwJ7Sux0NCxmE-bx8bLihQ','ABQIAAAAzr2EBOXUKnm_jVnk0OJI7xSosDVG8KKPE1-m51RBrvYughuyMxQ-i1QfUnH94QxWIa6N4U6MouMmBA','ABQIAAAAgdPfd74v_0Ttup6W0tJHtxQB4B98GOFQoxUPdFn0mOBvUSbzOxSwgIAcuwJ7Sux0NCxmE-bx8bLihQ'].shuffle.first
    elsif ENV['HEROKU_APP'] == 'commonplace-staging'
      'ABQIAAAAgdPfd74v_0Ttup6W0tJHtxSeiCNuZ_fCHJEwH48648-0ULan5RRVuO5xxDLGQXIjDZFCu8_6tlc8HQ'
    else
      'unknown_env_key'
    end
  end
end
