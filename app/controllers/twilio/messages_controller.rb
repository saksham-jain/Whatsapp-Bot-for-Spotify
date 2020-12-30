class Twilio::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :set_user

  def create
    track_keyword = params['Body']
    if track_keyword.to_i == 0
      tracks = RSpotify::Track.search(track_keyword).first(3)
      message = "Following are the track suggestions-\n"
      tracks.each_with_index { |track, i| message += "#{i+1}. #{track.name} by #{track.artists.map(&:name).join(',')}\n" } 
      message += "Please type a number to add track in liked songs" ##{playlist.name} playlist
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
      #playlist = @user.playlists.first

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
    @user = User.find_by(phone: params['From']) #User.find(session[:whatapp_user_id])
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

  def authenticate_user
    unless User.find_by(phone: params['From'])#session[:whatapp_user_id].present?
      client = Client.where("client_id like ?", "#{params['Body']}%").first
      if client
        #session[:whatapp_client_id] = client.id
        #session[:whatapp_user_id] = client.user.id
        client.user.update_attribute(:phone, params['From'])
        message = "You can now search for your song"
      else
        message = "I don't know your spotify account, please enter first 4 digit of your client_id"
      end
      response = Twilio::TwiML::MessagingResponse.new
      response.message(body: message)
      return render xml: response.to_xml
    end
  end
end
