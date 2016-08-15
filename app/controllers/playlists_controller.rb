# Controller for the creation and viewing of playlists
class PlaylistsController < ApplicationController
  def new
    if current_user
      if current_user.spotify_refresh_token?
        @favourites = User.get_user_favourite_tracks(current_user.spotify_refresh_token)
        @song_choices = @favourites['items'].each.map { |e| [e['name'],e['uri']]}
      end
      @mood_playlists = Playlist.get_mood_playlists
      @mood_choices = @mood_playlists['playlists']['items'].each.map { |e| [e['name'],e['id']]}
    else
      flash.now[:notice] = 'Please login or create an account.'
      redirect_to new_user_session_path
    end
  end

  def display
    if current_user
      begin
        if params[:playlist_type] == 'songs'
            @recommendations = Playlist.generate_song_playlist(params)
            @tracks = Playlist.extract_tracks(@recommendations)
            if current_user.spotify_refresh_token?
              @token = Playlist.get_spotify_access_token(current_user.spotify_refresh_token)
            end
            render 'view'
        elsif params[:playlist_type] == 'playlist'
            @mood_songs = Playlist.generate_mood_playlist(params)
            @tracks = Playlist.extract_playlist_tracks(@mood_songs)
            if current_user.spotify_refresh_token?
              @token = Playlist.get_spotify_access_token(current_user.spotify_refresh_token)
            end
            render 'view'
        elsif params[:playlist_type] == 'favourites'
          @favourites = User.get_user_favourite_tracks(current_user.spotify_refresh_token)
          @tracks = Playlist.extract_favourites_tracks(@favourites)
          if current_user.spotify_refresh_token?
            @token = Playlist.get_spotify_access_token(current_user.spotify_refresh_token)
          end
          render 'view'
          end
      rescue Exception => e
        Rails.logger.debug e
        flash.now[:error] = 'Something went wrong.'
        @mood_playlists = Playlist.get_mood_playlists
        @mood_choices = @mood_playlists['playlists']['items'].each.map { |e| [e['name'],e['id']]}
        @favourites = User.get_user_favourite_tracks(current_user.spotify_refresh_token)
        @song_choices = @favourites['items'].each.map { |e| [e['name'],e['uri']]}
        render 'new'
      end
    else
      redirect_to new_user_session_path
    end
  end

  def view
  end

  def show
    redirect_to new_playlist_path
  end

  def add_track_to_your_music
    token = Playlist.get_spotify_access_token(current_user.spotify_refresh_token)
    begin
      RestClient::Request.execute(method: :put,
                           url: "https://api.spotify.com/v1/me/tracks",
                           payload: '["' + params['id'] +'"]',
                           headers: {"Content-Type" => "application/json", :Authorization => "Bearer #{token}"}
                          )
      # RestClient.put "https://api.spotify.com/v1/me/tracks?ids=#{params["id"]}",
      #                :Authorization => "Bearer #{token}"
    rescue => e
      Rails.logger.debug e.response
    end
    render :nothing => true
  end
end
