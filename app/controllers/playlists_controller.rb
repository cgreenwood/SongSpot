# Controller for the creation and viewing of playlists
class PlaylistsController < ApplicationController
  def new
    if current_user
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
