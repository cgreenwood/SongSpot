desc "Update each users Positivity Score. Run weekly"
task :update_positivity_weekly => :environment do
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
      unless track_features['audio_features'].nil?
        track_features['audio_features'].each do |a|
          unless a.nil?
            Rails.logger.debug "#{a['valence']} => spotify:track:#{a['id']}"
            happiness += a['valence']
            track_count += 1
          end
        end
      end
      if track_count > 0
        positivity = happiness / 50
        u.old_positivity_score = u.positivity_score
        u.positivity_score = positivity
        u.save
      end
    end
  end
end
