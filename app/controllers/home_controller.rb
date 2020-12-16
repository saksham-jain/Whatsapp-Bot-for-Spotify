class HomeController < ApplicationController
  def index
  end

  def logged_in
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    session[:user_id] = spotify_user.id
    session[:access_token] = spotify_user.credentials.token
    session[:refresh_token] = spotify_user.credentials.refresh_token
  end
end
