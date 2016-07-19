# Controller for the creation and viewing of playlists
class PlaylistsController < ApplicationController
  def new
    if current_user
      if current_user.spotify_refresh_token?
        @favourites = User.get_user_favourite_tracks(current_user.spotify_refresh_token)
        @song_choices = @favourites['items'].each.map { |e| [e['track']['name'],e['track']['uri']]}
      end
    else
      flash.now[:notice] = 'Please login or create an account.'
      redirect_to new_user_session_path
    end
  end

  def display
    begin
      if current_user
        @recommendations = Playlist.generate_song_playlist(params)
        @tracks = Playlist.extract_tracks(@recommendations)
        if current_user.spotify_refresh_token?
          @token = Playlist.get_spotify_access_token(current_user.spotify_refresh_token)
        end
        render 'view'
      else
        redirect_to new_user_session_path
      end
    rescue Exception => e
      Rails.logger.debug e
      flash.now[:error] = 'Something went wrong.'
      render 'new'
    end
  end

  def view
  end

  def show
    redirect_to new_playlist_path
  end
end
