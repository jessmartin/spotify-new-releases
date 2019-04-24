require 'httparty'

# 1. Have your application request authorization; the user logs in and authorizes access
# https://accounts.spotify.com/authorize/

SPOTIFY_CLIENT_ID = "e3f4e0c2b60443c29893e9356dc48f8e"

auth_request_url = "https://accounts.spotify.com/authorize?client_id=#{SPOTIFY_CLIENT_ID}&response_type=code&redirect_uri=http%3A%2F%2Flocalhost:9292%2Fcallback&scope=user-follow-modify,user-library-read,playlist-read-collaborative,playlist-modify-private,user-modify-playback-state,streaming,app-remote-control,user-read-private,user-read-birthdate,user-read-playback-state,playlist-read-private,user-top-read,user-read-email,playlist-modify-public,user-library-modify,user-follow-read,user-read-currently-playing,user-read-recently-played"

# temporary code (lasts a few hours?)
code = "AQC3qb7C47ivzMnU0kLlg3bJkhGMCjCxnr-ETpyBP9W7ijyw53qAm4xb1pNypA6vWt3fu9BAfSfM5lbIbQTLC3gRrXUKDGIXlOEqaP8SRJ8geTXPYybxKQeWQsdXbPrV11U_jAmOo8Debq8YKpMKQTLWOfFiH_tzMev-LeB2ZLr01NJWQROSa4s9iAhDPGB4dYpnJDUt-BMb4T9u2R0X20i73_giWYT94-nW8hq_kYn2rmzMerwDh56C79MPs3A_xJaELoB6FfDyToYDRarpYh14a_oNepYvihej80um_pSS9n9myJtO4ns7bH6oyybu24b-exxhvK6gOFLcrx2YJjhNelEYp4_JZnef-qSTlQ0lylR552jxyZrXuIhMfxSwFQnGASo1C2ExOi7wNLXgRJgN2YY9xWeK0deKDaAXKJrggOFlHANohoRbHKKM7lWsvRgGvc0030BNK-gVGYgEfXzBc-E4KDEp9cTdk2yf_P9egLDn-z9RP3kV3ohoggUeSOI_zJ1zgoOwwv8t2KMbUULNCkjChwUT-MLHcV7oJxXrFU8eSYNg4K9-HlEYWVKX6qWvpAzkIpC9L5T8SDd7-1t5-6rCNb5cwWQQalXjdl-2zFxKKMv4MdUjNVYfvmX031Mx7wz53uGXw1kuh42fchx7sPUzZldiqhKdk5Cz-ykGNGZoZANjzgXQQSdPlSlauc2q8VLGwVvnVodB4PE"

# https://developer.spotify.com/documentation/general/guides/authorization-guide/

# 2. Have your application request refresh and access tokens; Spotify returns access and refresh tokens
# POST https://accounts.spotify.com/api/token

auth_response = HTTParty.post("https://accounts.spotify.com/api/token",
                              headers: { 'Accept' => 'application/json' },
                              body: {
                                'client_id' => SPOTIFY_CLIENT_ID,
                                'client_secret' => SPOTIFY_CLIENT_SECRET,
                                code: code,
                                grant_type: "authorization_code",
                                redirect_uri: "http://localhost:9292/callback"
                              })


access_token = auth_response['access_token']



# 3. Get my list of followed artists
# GET https://api.spotify.com/v1/me/following

followed_artists_response = HTTParty.get("https://api.spotify.com/v1/me/following", 
                                         query: { type: 'artist' },
                                         headers: {"Authorization" => "Bearer #{access_token}"})

followed_artists = followed_artists_response["artists"]["items"]

all_albums = followed_artists.collect do |artist|
  albums_response = HTTParty.get("https://api.spotify.com/v1/artists/#{artist["id"]}/albums", 
                                 headers: {"Authorization" => "Bearer #{access_token}"})
  albums_response["items"]
end.flatten

albums_in_last_30_days = all_albums.select do |album|
  next if album["release_date_precision"] != "day"
  Date.today - 365 < Date.parse(album["release_date"])
end