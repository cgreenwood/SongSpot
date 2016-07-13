class PlaylistsController < ApplicationController

  def new
    if current_user
    else
      redirect_to new_user_session_path
    end
  end

  def create
    if current_user
      @recommendations = Playlist.generate_song_playlist(params)
      @tracks = Playlist.extract_tracks(@recommendations)
      render 'show'
    else
      redirect_to new_user_session_path
    end
  end

  def show

  end

end
