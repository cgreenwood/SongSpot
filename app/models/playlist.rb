# Playlist Controller for editing
class Playlist
  def self.format_seeds(params)
    a = []
    (1..5).each { |i| a << params["seed_id_#{i}"].split(':').third }
    @seeds = a.select(&:present?).join(',')
  end

  def self.verify_params(params)
    @seeds = '4uLU6hMCjMI75M1A2tKUQC' unless @seeds.present?
    @limit = params[:limit].present? ? params[:limit] : 20
    @min_pop = params[:min_pop].present? ? params[:min_pop] : 50
    if params[:min_pop].to_i > 100 || params[:min_pop].to_i < 1
      @min_pop = params[:min_pop] = 50
    end
    if params[:limit].to_i > 100 || params[:limit].to_i < 1
      @limit = params[:limit] = 20
    end
  end

  def self.generate_song_playlist(params)
    format_seeds(params)
    verify_params(params)
    token = authorize
    response = RestClient.get 'https://api.spotify.com/v1/recommendations' \
                               "?limit=#{@limit}&market=#{params[:market]}" \
                               "&min_popularity=#{@min_pop}" \
                               "&seed_tracks=#{@seeds}",
                              'Authorization' => "Bearer #{token}"
    data = JSON.parse(response)
  end

  def self.generate_mood_playlist(params)
    token = authorize
    playlists = get_mood_playlists
    response = RestClient.get "https://api.spotify.com/v1/users/spotify/playlists/#{params[:mood]}/tracks",
                              'Authorization' => "Bearer #{token}"
    data = JSON.parse(response)
  end

  def self.authorize
    base64 = Base64.urlsafe_encode64(ENV['SPOTIFY_CLIENT_ID'] + ':' +
                                     ENV['SPOTIFY_SECRET_ID'])
    response = RestClient.post 'https://accounts.spotify.com/api/token',
                               { 'grant_type' => 'client_credentials' },
                               'Authorization' => "Basic #{base64}"
    data = JSON.parse(response)
    data['access_token']
  end

  def self.extract_tracks(recommendations)
    tracks = []
    recommendations['tracks'].each do |e|
      tracks << e['id']
    end
    tracks = tracks.join(',')
  end

  def self.extract_playlist_tracks(trackset)
    tracks = []
    trackset['items'].each do |e|
      tracks << e['track']['id']
    end
    tracks = tracks.join(',')
  end

  def self.extract_favourites_tracks(favourites)
    tracks = []
    favourites['items'].each do |e|
      tracks << e['id']
    end
    tracks = tracks.join(',')
  end

  def self.get_spotify_access_token(user_refresh_token)
    base64 = Base64.urlsafe_encode64(ENV['SPOTIFY_CLIENT_ID'] + ':' +
                                     ENV['SPOTIFY_SECRET_ID'])
    response = RestClient.post 'https://accounts.spotify.com/api/token',
                                      { 'grant_type' => 'refresh_token',
                                'refresh_token' => user_refresh_token },
                                    'Authorization' => "Basic #{base64}"
    data = JSON.parse(response)
    data['access_token']
  end

  def self.get_mood_playlists
    token = authorize
    response = RestClient.get "https://api.spotify.com/v1/browse/categories/mood/playlists",
                              'Authorization' => "Bearer #{token}"
    data = JSON.parse(response)
  end



  end
