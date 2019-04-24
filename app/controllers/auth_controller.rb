class AuthController < ApplicationController
  def index
    @client_id = Rails.application.secrets.spotify_client_id
    @redirect_uri = "http://localhost:3000/callback"
  end

  def callback
    @code = params[:code]

    @access_token = get_access_token(@code)

    session[:access_token] = @access_token
  end

  private

  def get_access_token(code)
    auth_response = HTTParty.post("https://accounts.spotify.com/api/token",
                                  headers: { 'Accept' => 'application/json' },
                                  body: {
                                    'client_id' => Rails.application.secrets.spotify_client_id,
                                    'client_secret' => Rails.application.secrets.spotify_client_secret,
                                    code: code,
                                    grant_type: "authorization_code",
                                    redirect_uri: "http://localhost:3000/callback"
                                  })
    auth_response['access_token']
  end
end
