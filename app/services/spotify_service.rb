require 'securerandom'
require 'httparty'

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

    user = User.create(
      access_token: auth_response['access_token'],
      refresh_token: auth_response['refresh_token'],
      token_type: auth_response['token_type'],
      expires_in: Time.now + auth_response['expires_in'].to_i,
      remember_token: SecureRandom.uuid,
    )

    user
  end

  def self.get_recent_albums_for(user:, released_after:)
    # Get all artists for user (in chunks of 50)
    # Get all albums for _each_ artist (in chunks of 50)
    # Sort the albums by release date
    # Group into weeks
    # Cache Artist and Album Responses for Each User

    followed_artists_response = HTTParty.get("https://api.spotify.com/v1/me/following", 
      query: { type: 'artist' },
      headers: {"Authorization" => "Bearer #{user.access_token}"})
    followed_artists = followed_artists_response["artists"]["items"]

    all_albums = followed_artists.collect do |artist|
      albums_response = HTTParty.get("https://api.spotify.com/v1/artists/#{artist["id"]}/albums", 
                                      headers: {"Authorization" => "Bearer #{user.access_token}"})
      albums_response["items"]
    end.flatten

    # all_albums.select do |album|
    #   next if album["release_date_precision"] != "day"
    #   Date.today - 14 < Date.parse(album["release_date"])
    # end
  end
end