class Playlist

  def self.generate_song_playlist(params)

    a = [params[:seed_id_1].split(":").third,
         params[:seed_id_2].split(":").third,
         params[:seed_id_3].split(":").third,
         params[:seed_id_4].split(":").third,
         params[:seed_id_5].split(":").third]

    seeds = a.select { |e| e.present? }.join(",")
    unless seeds.present?
      seeds = "4uLU6hMCjMI75M1A2tKUQC"
    end

    if params[:min_pop].to_i > 100 || params[:min_pop].to_i < 1
      params[:min_pop] = 20
    end

    unless params[:limit].present?
      params[:limit] = 20
    end

    unless params[:min_pop].present?
      params[:min_pop] = 50
    end


    token = authorize
    response = RestClient.get "https://api.spotify.com/v1/recommendations?limit=#{params[:limit]}&market=#{params[:market]}&min_popularity=#{params[:min_pop]}&seed_tracks=#{seeds}",
                                     {"Authorization" => "Bearer #{token}"}

    recommendations = JSON.parse(response)
    return recommendations

  end

  def self.authorize
    base64 = Base64.urlsafe_encode64(ENV["SPOTIFY_CLIENT_ID"] + ":" +
                            ENV["SPOTIFY_SECRET_ID"])
    response = RestClient.post "https://accounts.spotify.com/api/token",
                               {"grant_type" => "client_credentials"},
                               {"Authorization" => "Basic #{base64}"}
    data = JSON.parse(response)
    token = data["access_token"]
  end

  def self.extract_tracks(recommendations)
    tracks = []
    recommendations["tracks"].each do |e|
      tracks << e["id"]
    end
    tracks = tracks.join(",")
    Rails.logger.debug(tracks)
    return tracks
  end

end
