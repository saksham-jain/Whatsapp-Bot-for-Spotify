require 'rspotify/oauth'
Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :spotify, scope: 'user-read-email playlist-modify-public user-library-read user-library-modify'
end
