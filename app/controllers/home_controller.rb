class HomeController < ApplicationController
  def index
  end

  def logged_in
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
  end
end
