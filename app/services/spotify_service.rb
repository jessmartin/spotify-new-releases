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
    followed_artists_response = HTTParty.get("https://api.spotify.com/v1/me/following", 
      query: { type: 'artist', limit: 50 }, 
      headers: {"Authorization" => "Bearer #{user.access_token}"})
    followed_artists = followed_artists_response["artists"]["items"]

    until followed_artists_response["artists"]["next"].blank?
      last_artist_id = followed_artists_response["artists"]["cursors"]["after"]

      followed_artists_response = HTTParty.get("https://api.spotify.com/v1/me/following", 
        query: { type: 'artist', after: last_artist_id, limit: 50 }, 
        headers: {"Authorization" => "Bearer #{user.access_token}"})
      followed_artists = followed_artists_response["artists"]["items"]
    end

    all_albums = followed_artists.collect do |artist|
      albums_response = HTTParty.get("https://api.spotify.com/v1/artists/#{artist["id"]}/albums", 
                                      headers: {"Authorization" => "Bearer #{user.access_token}"})
      albums_response["items"]
    end.flatten

    if released_after
      all_albums.select do |album|
        next if album["release_date_precision"] != "day"
        released_after < Date.parse(album["release_date"])
      end
    end

    all_albums.select { |a| a["release_date_precision"] == "day" }
                    .sort { |a, b| b["release_date"] <=> a["release_date"] }
  end
end