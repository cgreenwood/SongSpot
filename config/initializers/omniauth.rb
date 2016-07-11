require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, "afd3cd8864a449a6811e4b28082d9a82", "b58552069d41431698c1dc2ecc42b673", scope: 'user-read-email playlist-modify-public user-library-read user-library-modify'
end
