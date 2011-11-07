# Refine our environment
CP_ENV = ( ENV['HEROKU_APP'] == 'commonplace' ) ? 'production' : 'staging'

#p "Loading env: #{Rails.env}"
#require "sinatra/reloader" if development? # not quite sure where to properly put this
