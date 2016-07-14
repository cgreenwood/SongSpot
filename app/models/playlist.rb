# Playlist Controller for editing
class Playlist
  def self.format_seeds(params)
    a = []
    (1..5).each { |i| a << params["seed_id_#{i}"].split(':').third }
    @seeds = a.select(&:present?).join(',')
  end

  def self.verify_params(params)
    @seeds = '4uLU6hMCjMI75M1A2tKUQC' unless @seeds.present?
    if params[:min_pop].to_i > 100 || params[:min_pop].to_i < 1
      @min_pop = params[:min_pop] = 20
    end
    @limit = params[:limit] = 20 unless params[:limit].present?
    @min_pop = params[:min_pop] = 50 unless params[:min_pop].present?
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
    JSON.parse(response)
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
    tracks
  end

  def self.track_to_favourite(track)
    favourite = {}
    favourite['track_id'] = track['id']
    favourite['track_name'] = track['name']
    favourite['artist_name'] = track['artists'].first['name']
    favourite['album_name'] = track['album']['name']
    favourite['album_art'] = track['album']['images'].third['url']
  end
end
