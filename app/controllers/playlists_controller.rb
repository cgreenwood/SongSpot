class PlaylistsController < ApplicationController

  def new
  end

  def create
    Playlist.generate_song_playlist(params)
  end
end
