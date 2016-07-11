require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SongSpot
  class Application < Rails::Application
    RSpotify::authenticate("afd3cd8864a449a6811e4b28082d9a82",
                           "b58552069d41431698c1dc2ecc42b673")

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
