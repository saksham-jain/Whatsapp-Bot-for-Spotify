class ClientsController < ApplicationController
  def new
  end

  def create
    @client = Client.create(client_params)
    session[:client_id] = client_params[:client_id]
    session[:client_secret] = client_params[:client_secret]
    redirect_to root_path
  end

  private

  def client_params
    params.require(:client).permit(:client_id, :client_secret)
  end
end
