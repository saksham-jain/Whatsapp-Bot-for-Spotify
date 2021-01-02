class Twilio::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :setup_user, if: -> { params['Body'].split.first.eql? '#self' }
  before_action :set_user

  def create
    track_keyword = params['Body']
    if track_keyword.to_i == 0
      tracks = RSpotify::Track.search(track_keyword).first(3)
      message = "Following are the track suggestions-\n"
      tracks.each_with_index { |track, i| message += "#{i+1}. #{track.name} by #{track.artists.map(&:name).join(',')}\n" } 
      message += "Please type a number to add track in liked songs"
    else
      user_id = @user.user_id
      token = @user.access_token
      refresh_token = @user.refresh_token
      @user = RSpotify::User.new({
            'id' => user_id,
            'credentials' => {
              'token' => token,
              'refresh_token' => refresh_token
            }})

      track = RSpotify::Track.search(session[:track_keyword]).first(3)[track_keyword.to_i - 1]
      #If you want to add in playlist
        #track_uri = track.uri    
        #playlist.add_tracks!([track_uri])   
      #If you want to add in liked song
      @user.save_tracks!([track])
      message = "Track is added in liked songs successfully!!"
    end

    send_message message
    session[:track_keyword] = track_keyword
  end

  private

  def set_user
    @user = User.find_by(phone: params['From']) || User.first
    if @user.access_token_expired?
      request_body = {
        grant_type: 'refresh_token', 
        refresh_token: @user.refresh_token,
        client_id: @user.client.client_id,
        client_secret: @user.client.client_secret
      }
      response = RestClient.post('https://accounts.spotify.com/api/token', request_body)
      json_response = JSON.parse(response)
      @user.update(access_token: json_response["access_token"])
    end
  end

  def setup_user
    client = Client.where("client_id like ?", "#{params['Body'].split.last}%").first
    if client
      client.user.update_attribute(:phone, params['From'])
      message = "Your Spotify account is linked now!\nYou can now search and like the song"
      send_message message
    else
      message = "You have entered wrong ClientId\n Or you may have not registered first"
      send_message message
    end
  end

  def send_message message
    response = Twilio::TwiML::MessagingResponse.new
    response.message(body: message)
    return render xml: response.to_xml
  end
end
