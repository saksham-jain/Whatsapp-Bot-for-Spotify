class Twilio::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    body = params['Body']
    track = RSpotify::Track.search(body).first
    message = "Did you want to add _#{track.name}_ by _#{track.artists.map(&:name).to_sentence}_?"

    response = Twilio::TwiML::MessagingResponse.new
    response.message(body: message)
    render xml: response.to_xml
  end
end
