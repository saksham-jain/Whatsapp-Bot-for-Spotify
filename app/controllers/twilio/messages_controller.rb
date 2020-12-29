class Twilio::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user
  def create
    user_id = @user.user_id
    token = @user.access_token
    refresh_token = @user.refresh_token
    @user = RSpotify::User.new({
          'id' => user_id,
          'credentials' => {
            'token' => token,
            'refresh_token' => refresh_token
          }})
    playlist = @user.playlists.first

    track_keyword = params['Body']
    if track_keyword.to_i == 0
      tracks = RSpotify::Track.search(track_keyword).first(3)
      message = "Following are the track suggestions-\n"
      tracks.each_with_index { |track, i| message += "#{i+1}. #{track.name} by #{track.artists.map(&:name).join(',')}\n" } 
      message += "Please type a number to add track in #{playlist.name} playlist"
    else
      track = RSpotify::Track.search(session[:track_keyword]).first(3)[track_keyword.to_i - 1]
      #If you want to add in playlist
        #track_uri = track.uri    
        #playlist.add_tracks!([track_uri])   
      #If you want to add in liked song
      @user.save_tracks!([track])
      message = "Track is added successfully!!"
    end
    response = Twilio::TwiML::MessagingResponse.new
    response.message(body: message)
    render xml: response.to_xml

    session[:track_keyword] = track_keyword
  end

  private

  def set_user
    @user = User.first
    if @user.access_token_expired?
      request_body = {
        grant_type: 'refresh_token', 
        refresh_token: @user.refresh_token,
        client_id: ENV['SPOTIFY_KEY'],
        client_secret: ENV['SPOTIFY_SECRET']
      }
      response = RestClient.post('https://accounts.spotify.com/api/token', request_body)
      json_response = JSON.parse(response)
      @user.update(access_token: json_response["access_token"])
    end
  end
end
