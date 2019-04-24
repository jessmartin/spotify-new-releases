class SpotifyService

  def self.authenticate(code)
    # Trade in the Spotify Access Code for an Access Token
    auth_response = HTTParty.post("https://accounts.spotify.com/api/token",
                                  headers: { 'Accept' => 'application/json' },
                                  body: {
                                    'client_id' => Rails.application.secrets.spotify_client_id,
                                    'client_secret' => Rails.application.secrets.spotify_client_secret,
                                    code: code,
                                    grant_type: "authorization_code",
                                    redirect_uri: "http://localhost:3000/callback"
                                  })
    auth_response['access_token'] ? true : false
    # Store the access token and refresh token in the database by "user id"
    # Return true if all goes well
  end

end