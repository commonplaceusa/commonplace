# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_commonplace_session',
  :secret      => '02b8a3c04f5b1b0f661c653a1c1543b5041f4a77f4998c02048228ef90d213e9cbf4c4f0ffb85d09c3c30f23c5de7557f31b999f83db6a85de612fbfe7a737c7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
