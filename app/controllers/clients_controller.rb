class ClientsController < ApplicationController
  def new
  end

  def create
    @client = Client.create(client_params)
    redirect_to root_path
  end

  private

  def client_params
    params.require(:client).permit(:client_id, :client_secret)
  end
end
