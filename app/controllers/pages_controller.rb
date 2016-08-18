# Pages controller for displaying the basic pages (home,about,contact,help)
class PagesController < ApplicationController
  def home
    @articles = Article.all.order(created_at: :desc)
  end

  def about
  end

  def contact
  end

  def help
  end

  def send_to_slack
    all_channels = User.get_slack_channels
    channels = User.select_channels(all_channels)
    @users = User.all.select { |u| u.positivity_score }
    @users = @users.sort_by { |u| u.positivity_score }.reverse
    ciab_users = User.get_ciab_users(@users)
    message = User.create_message(ciab_users)
    User.send_to_slack(channels,"check-in",message)
    Rails.logger.debug channels
    redirect_to positivity_path
  end

  def show_positivity
    @users = User.all.select { |u| u.positivity_score }
    @users = @users.sort_by { |u| u.positivity_score.to_i }.reverse
  end

  def callback
    url = ERB::Util.url_encode(ENV['CALLBACK_URL'])
    base64 = Base64.urlsafe_encode64(ENV['SPOTIFY_CLIENT_ID'] + ':' +
                                     ENV['SPOTIFY_SECRET_ID'])
    response = RestClient.post 'https://accounts.spotify.com/api/token',
                                { 'grant_type' => "authorization_code",
                                  'code' => params[:code],
                                'redirect_uri' => url },
                                'Authorization' => "Basic #{base64}"
    data = JSON.parse(response)
    Rails.logger.debug "=" * 100
    Rails.logger.debug data
    Rails.logger.debug "=" * 100
    token = data['refresh_token']
    current_user.update_attributes(spotify_refresh_token: token)
    User.update_positivity
    redirect_to user_path(current_user)
  end
end
