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

  def self.update_positivity
    User.all.each do |u|
      if u.spotify_refresh_token?
        favourites = User.get_user_favourite_tracks(u.spotify_refresh_token)
        track_ids = []
        favourites['items'].each do |e|
          track_ids << e['id']
        end
        track_ids = track_ids.join(',')
        track_features = User.get_audio_features_of_favourites(track_ids)
        happiness = 0.00
        track_features['audio_features'].each do |a|
          Rails.logger.debug "#{a['valence']} => spotify:track:#{a['id']}"
          happiness += a['valence']
        end
        positivity = happiness / 50
        u.positivity_score = positivity
        u.save
      end
    end
  end

  def self.get_user_favourite_tracks(user_refresh_token)
    token = Playlist.get_spotify_access_token(user_refresh_token)
    base64 = Base64.urlsafe_encode64(ENV['SPOTIFY_CLIENT_ID'] + ':' +
                                     ENV['SPOTIFY_SECRET_ID'])
    # For top tracks use /top/tracks but first get user-top-read
    response = RestClient.get 'https://api.spotify.com/v1/me/top/tracks?limit=50',
                              'Authorization' => "Bearer #{token}"
    data = JSON.parse(response)
  end

  def self.get_audio_features_of_favourites(track_ids)
    access_token = Playlist.authorize
    response = RestClient.get "https://api.spotify.com/v1/audio-features?ids=#{track_ids}",
                  'Authorization' => "Bearer #{access_token}"
    data = JSON.parse(response)
  end

end
