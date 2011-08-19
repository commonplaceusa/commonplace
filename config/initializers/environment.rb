# Refine our environment
CP_ENV = ( ENV['HEROKU_APP'] == 'commonplace' ) ? 'production' : 'staging'
