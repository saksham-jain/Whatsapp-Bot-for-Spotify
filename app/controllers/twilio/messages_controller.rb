class Twilio::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    grant = Base64.encode64("#{ENV['SPOTIFY_KEY']}:#{ENV['SPOTIFY_SECRET']}").delete("\n")

    resp = RestClient.post('https://accounts.spotify.com/api/token',
                           {'grant_type' => 'client_credentials'},
                           {"Authorization" => "Basic #{grant}"})
    
    session[:access_token] = JSON.parse(resp)['access_token']

    user_id = ENV['SPOTIFY_USER_ID'] 
    token = session[:access_token] #ENV['SPOTIFY_USER_TOKEN'] 

    @user = RSpotify::User.new({
          'id' => user_id,
          'credentials' => {
            'token' => token
          }})
    playlist = @user.playlists.first

    track_keyword = params['Body']
    if track_keyword.to_i == 0
      tracks = RSpotify::Track.search(track_keyword).first(3)
      message = "Following are the track suggestions-\n"
      tracks.each_with_index { |track, i| message += "#{i+1}. #{track.name} by #{track.artists.map(&:name).join(',')}\n" } 
      message += "Please type a number to add track in #{playlist.name} playlist"
    else
      byebug
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
end
