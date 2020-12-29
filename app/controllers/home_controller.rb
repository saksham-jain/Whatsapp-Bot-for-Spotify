class HomeController < ApplicationController
  def index
  end

  def logged_in
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @user_id = spotify_user.id
    @credentials = spotify_user.credentials
    @user = User.find_by(user_id: @user_id)
    if @user
      @user.update(access_token: @credentials.token, refresh_token: @credentials.refresh_token)
    else
      User.create(user_id: @user_id, access_token: @credentials.token, refresh_token: @credentials.refresh_token)
    end
  end
end
