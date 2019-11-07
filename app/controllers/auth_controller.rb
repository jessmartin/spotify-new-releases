class AuthController < ApplicationController
  def index
    # Look up the user's "remember token" from their session
    # If they have one, then look up the user's access token from the data store
    # If the access token is valid, redirect the user to releases#index
    # SpotifyService.authenticated?(user_id)

    # Render the button to connect to Spotify
    @client_id = Rails.configuration.spotify_client_id
    @redirect_uri = "#{Rails.configuration.domain}/callback"
  end

  def callback
    code = params[:code]

    user = SpotifyService.authenticate(code)

    cookies.permanent[:remember_token] = user.remember_token
  end
end
