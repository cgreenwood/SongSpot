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

  def self.get_slack_channels
    response = RestClient.get "https://slack.com/api/channels.list?token=#{ENV['USER_SLACK_TOKEN']}"
    data = JSON.parse(response)
  end

  def self.select_channels(all_channels)
    channels = []
    all_channels['channels'].each do |c|
      channels << {'name' => c['name'], 'id' => c['id']}
    end
    return channels
  end

  def self.get_ciab_users(users)
    ciab_users = []
    users.each do |u|
      if (u.name == "Carl Greenwood" || u.name == "Jamie Cleare" ||
          u.name == "Will Stokely" || u.name == "adam" || u.name == "Kevin Hughes" ||
          u.name == "alex")
          ciab_users << u
        end
      end
      return ciab_users
  end

  def self.get_movement(user)
    if user.positivity_score > user.old_positivity_score
      return "Up from last week."
    elsif user.positivity_score < user.old_positivity_score
      return "Down from last week."
    else
      return "Same as last week."
    end
  end

  def self.create_message(ciab_users)
    message = "Positivity Scores: \n"
    rank = 1
    ciab_users.each do |u|
      movement = get_movement(u)
      score = (u.positivity_score * 100).round(2)
      message = message + "#{rank} - #{u.name.split(" ").first} - #{score}/100 - #{movement}\n "
      rank += 1
    end
    message = message + "\n #{ciab_users.last.name.split(" ").first} are you feeling a litte down? \n"
    message = message + "How about some happy music? https://open.spotify.com/user/spotify/playlist/2PXdUld4Ueio2pHcB6sM8j"
    return message
  end

  def self.send_to_slack(channels,channel_name,message)
    RestClient.post 'https://slack.com/api/chat.postMessage',
                    {'token' => ENV['USER_SLACK_TOKEN'],
                     'channel' => channel_name,
                     'text' => message,
                     'as_user' => 'false',
                     'username' => 'SongSpot Bot'}
  end


  def self.link_spotify
    url = ERB::Util.url_encode('http://localhost:3000/callback')
    redirect_to 'https://accounts.spotify.com/authorize' \
                               "?client_id=#{ENV['SPOTIFY_CLIENT_ID']}" \
                               "&response_type=code&redirect_uri=#{url}"
  end

  def self.update_positivity
    User.all.each do |u|
      if u.spotify_refresh_token?
        favourites = User.get_user_favourite_tracks_short(u.spotify_refresh_token)
        track_ids = []
        favourites['items'].each do |e|
          track_ids << e['id']
        end
        track_ids = track_ids.join(',')
        track_features = User.get_audio_features_of_favourites(track_ids)
        happiness = 0.00
        track_count = 0
        unless track_features['audio_features'].nil?
          track_features['audio_features'].each do |a|
            unless a.nil?
              Rails.logger.debug "#{a['valence']} => spotify:track:#{a['id']}"
              happiness += a['valence']
              track_count += 1
            end
        end
        if track_count > 0
          positivity = happiness / track_count
          u.positivity_score = positivity
          u.save
        end
      end
    end
  end

  def self.get_user_favourite_tracks_short(user_refresh_token)
    unless user_refresh_token.nil?
      token = Playlist.get_spotify_access_token(user_refresh_token)
      base64 = Base64.urlsafe_encode64(ENV['SPOTIFY_CLIENT_ID'] + ':' +
                                       ENV['SPOTIFY_SECRET_ID'])
      # For top tracks use /top/tracks but first get user-top-read
      response = RestClient.get 'https://api.spotify.com/v1/me/top/tracks?limit=50&time_range=short_term',
                                'Authorization' => "Bearer #{token}"
      data = JSON.parse(response)
      i = 0
      data['items'].each do |e|
        i += 1
      end
      if i < 25
        response = RestClient.get 'https://api.spotify.com/v1/me/top/tracks?limit=50&time_range=medium_term',
                                  'Authorization' => "Bearer #{token}"
        data = JSON.parse(response)
      end
      return data
    end
  end



  def self.get_user_favourite_tracks(user_refresh_token)
    unless user_refresh_token.nil?
      token = Playlist.get_spotify_access_token(user_refresh_token)
      base64 = Base64.urlsafe_encode64(ENV['SPOTIFY_CLIENT_ID'] + ':' +
                                      ENV['SPOTIFY_SECRET_ID'])
    # For top tracks use /top/tracks but first get user-top-read
      response = RestClient.get 'https://api.spotify.com/v1/me/top/tracks?limit=50&time_range=medium_term',
                              'Authorization' => "Bearer #{token}"

      data = JSON.parse(response)
      i = 0
      data['items'].each do |e|
        i += 1
      end
      if i < 25
        response = RestClient.get 'https://api.spotify.com/v1/me/top/tracks?limit=50&time_range=medium_term',
                                  'Authorization' => "Bearer #{token}"
        data = JSON.parse(response)
      end

      return data
    end
  end

  def self.get_audio_features_of_favourites(track_ids)
    access_token = Playlist.authorize
    response = RestClient.get "https://api.spotify.com/v1/audio-features?ids=#{track_ids}",
                  'Authorization' => "Bearer #{access_token}"
    data = JSON.parse(response)
  end

end
