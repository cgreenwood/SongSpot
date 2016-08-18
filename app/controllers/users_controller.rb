# Users Controller used for displaying user pages.
class UsersController < ApplicationController
  def show
    if current_user && (User.find(params[:id]).name == current_user.name || current_user.admin?)
      if User.find(params[:id].spotify_refresh_token?
        User.update_positivity
        @favourites = User.get_user_favourite_tracks(User.find(params[:id]).spotify_refresh_token)
      end
      @user = User.find(params[:id])
    else
      redirect_to root_path
    end
  end

  def link_spotify
    url = ERB::Util.url_encode(ENV['CALLBACK_URL'])
    redirect_to 'https://accounts.spotify.com/authorize' \
                               "?client_id=#{ENV['SPOTIFY_CLIENT_ID']}" \
                               "&response_type=code&redirect_uri=#{url}" \
                               "&scope=user-top-read%20user-library-modify"
  end
end
