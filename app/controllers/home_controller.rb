class HomeController < ApplicationController
  def index
  end

  def logged_in
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @user_id = spotify_user.id
    @credentials = spotify_user.credentials
  end
end
