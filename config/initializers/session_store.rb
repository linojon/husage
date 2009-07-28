# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_hughes_session',
  :secret      => 'd2dadc3c03fc2fe04fea072baabcaf5ecc24a5f08b96f249796227383ad0ca1f27a4f9e2dd386fce6339addb972d5d8a3d72c14a60ca42d2bd5e6f1d486ce199'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
