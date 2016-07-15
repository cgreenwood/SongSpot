# User model where modules are defined.
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :comments
  has_many :articles
  has_many :bugs
  serialize :favourites, Array

  def link_spotify
    response = RestClient.get 'https://accounts.spotify.com/authorize', \
                              "?client_id=#{ENV['SPOTIFY_CLIENT_ID']}" \
                              '&response_type=code&redirect_uri=http://localhost:3000/callback'
    Rails.logger.debug response
  end
end

# def self.generate_song_playlist(params)
#   format_seeds(params)
#   verify_params(params)
#   token = authorize
#   response = RestClient.get 'https://api.spotify.com/v1/recommendations' \
#                              "?limit=#{@limit}&market=#{params[:market]}" \
#                              "&min_popularity=#{@min_pop}" \
#                              "&seed_tracks=#{@seeds}",
#                             'Authorization' => "Bearer #{token}"
#   JSON.parse(response)
# end
#
# def self.authorize
#   base64 = Base64.urlsafe_encode64(ENV['SPOTIFY_CLIENT_ID'] + ':' +
#                                    ENV['SPOTIFY_SECRET_ID'])
#   response = RestClient.post 'https://accounts.spotify.com/api/token',
#                              { 'grant_type' => 'client_credentials' },
#                              'Authorization' => "Basic #{base64}"
#   data = JSON.parse(response)
#   data['access_token']
# end
