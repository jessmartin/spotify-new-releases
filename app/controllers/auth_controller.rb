class AuthController < ApplicationController
  def index
    @client_id = Rails.application.secrets.spotify_client_id
    @redirect_uri = "http://localhost:3000/callback"
  end

  def callback
    @code = params[:code]
  end
end
