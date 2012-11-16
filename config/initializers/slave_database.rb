# if ENV['READ_ONLY_DATABASE'] == 'true'
  # begin
    # ActiveRecord::Base.establish_connection(ENV['HEROKU_POSTGRESQL_IVORY_URL'])
  # rescue => ex
    # # We couldn't connect.
    # # This isn't a huge deal, since it's a performance optimization
    # # Nothing's going to break. However, we should probably notify Airbrake...
    # if Rails.env.production?
      # Airbrake.notify_or_ignore(
        # :error_class   => "Error connecting to read-only database slave",
        # :error_message => ex.message,
        # :parameters    => {
          # database_url: ENV['HEROKU_POSTGRESQL_IVORY_URL'],
          # read_only_flag: ENV['READ_ONLY_DATABASE'] || 'false'
        # }
      # )
    # end
    # # This is also convenient in that development will always use the same database
  # end
# end
