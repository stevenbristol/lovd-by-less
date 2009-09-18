# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
# WARNING: You MUST generate a new secret (use "rake secret") and add it below!
ActionController::Base.session = {
  :key         => '_lovdbyless_session',
  :secret      => 'd009952e4f799158c1d002583cf8090d0b97e1ec825f9910aa5227f7062838a0a2f767d5e31ee518dfe50db976c2e6294ad596f829c07915701c11b3d84682ec'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
