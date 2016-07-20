# Pages controller for displaying the basic pages (home,about,contact,help)
class PagesController < ApplicationController
  def home
    @articles = Article.all
  end

  def about
  end

  def contact
  end

  def help
  end

  def show_positivity
    @users = User.all.select { |u| u.positivity_score }
    @users = @users.sort_by { |u| u.positivity_score }
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
    token = data['refresh_token']
    current_user.update_attributes(spotify_refresh_token: token)
    User.update_positivity
    redirect_to user_path(current_user)
  end
end
