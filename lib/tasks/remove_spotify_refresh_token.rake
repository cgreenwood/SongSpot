desc "Remove every users refresh token"
task :remove_refresh => :environment do
  User.all.each do |u|
    if u.spotify_refresh_token?
      u.spotify_refresh_token = nil
      u.save
      Rails.logger.debug "#{u['name']} - Refresh token deleted."
    end
  end
end
