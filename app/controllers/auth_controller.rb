class AuthController < ApplicationController
  def index
    # Look up the user's "user id" from their session
    # If they have one, then look up the user's access token from the data store
    # If the access token is valid, redirect the user to releases#index
    # SpotifyService.authenticated?(user_id)


    # Render the button to connect to Spotify
    @client_id = Rails.application.secrets.spotify_client_id
    @redirect_uri = "http://localhost:3000/callback"
  end

  def callback
    code = params[:code]

    # Trade in the Spotify Access Code for an Access Token
    # SpotifyService.authenticate(code)
      # if returns true, then it was successful and render the page (redirect to releases#index)
      # if returns false, then show the unsuccessful page

    # access_token = get_access_token(code)

    session[:access_token] = access_token
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
