class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @param = {
      client_id: ENV['SPOTIFY_KEY'],
      response_type: "code",
      scope: 'user-read-email playlist-modify-public user-library-read user-library-modify',
      redirect_uri: 'https://e5d89eb3486d.ngrok.io/auth/spotify/callback',
      show_dialog: true
    }
    @url = "https://accounts.spotify.com/authorize?"
  end

  def log_in
    param = {
      grant_type: "authorization_code",
      code: params[:code],
      redirect_uri: 'https://e5d89eb3486d.ngrok.io/auth/spotify/callback',
      client_id: ENV['SPOTIFY_KEY'],
      client_secret: ENV['SPOTIFY_SECRET']
    }

    resp = RestClient.post('https://accounts.spotify.com/api/token', param)
    json_resp = JSON.parse(resp)
    
    header = { Authorization: "Bearer #{json_resp["access_token"]}" }

    final_resp = RestClient.get('https://api.spotify.com/v1/me', header)

    user_params = JSON.parse(final_resp)

    spotify_user = RSpotify::User.new(
    {
      'id' => user_params['id'],
      'credentials' => {
        "token" => json_resp["access_token"],
        "refresh_token" => json_resp["refresh_token"]
      }
    })

    @user_id = spotify_user.id

    @credentials = spotify_user.credentials
    @user = User.find_by(user_id: @user_id)
    if @user
      @user.update(access_token: json_resp["access_token"], refresh_token: json_resp["refresh_token"])
    else
      @user = User.create(user_id: @user_id, access_token: json_resp["access_token"], refresh_token: json_resp["refresh_token"])
    end
  end
end
