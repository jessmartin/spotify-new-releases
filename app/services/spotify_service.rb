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

    return false unless auth_response.success?

    access_token = AccessToken.create(
      access_token: auth_response['access_token'],
      refresh_token: auth_response['refresh_token'],
      token_type: auth_response['token_type'],
      expires_in: Time.now + auth_response['expires_in'].to_i,
    )

    access_token ? true : false
  end

end