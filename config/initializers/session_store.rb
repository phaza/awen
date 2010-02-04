# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_awen_session',
  :secret      => '433800d0e83c0c527e296d9791f169b4142334263738704fd049c7df541e165398e7d14d1d0ec12f56362ef19d447d8987bc3e266a0158c5ebfff6d23492c74e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
