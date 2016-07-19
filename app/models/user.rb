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

  def self.link_spotify
    url = ERB::Util.url_encode('http://localhost:3000/callback')
    redirect_to 'https://accounts.spotify.com/authorize' \
                               "?client_id=#{ENV['SPOTIFY_CLIENT_ID']}" \
                               "&response_type=code&redirect_uri=#{url}"
  end

  def self.get_user_favourite_tracks(user_refresh_token)
    token = Playlist.get_spotify_access_token(user_refresh_token)
    base64 = Base64.urlsafe_encode64(ENV['SPOTIFY_CLIENT_ID'] + ':' +
                                     ENV['SPOTIFY_SECRET_ID'])
    # For top tracks use /top/tracks but first get user-top-read
    response = RestClient.get 'https://api.spotify.com/v1/me/top/tracks?limit=50',
                              'Authorization' => "Bearer #{token}"
    data = JSON.parse(response)
    return data

  end
end
