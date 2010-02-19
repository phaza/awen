# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_awen_session',
  :secret => '6e110a95714f3507b910a3b7c6b5c4b1a2ea8c6454484feed0849e3a3124fa9059fd28a059e63a0a69a67d145d47b0338b01aaf988beffd48c7266247b239b52'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
