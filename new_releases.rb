require 'httparty'

# 1. Have your application request authorization; the user logs in and authorizes access
# https://accounts.spotify.com/authorize/

auth_request_url = "https://accounts.spotify.com/authorize?client_id=#{SPOTIFY_CLIENT_ID}&response_type=code&redirect_uri=https%3A%2F%2Flocalhost:9292%2Fcallback&scope=user-follow-modify,user-library-read,playlist-read-collaborative,playlist-modify-private,user-modify-playback-state,streaming,app-remote-control,user-read-private,user-read-birthdate,user-read-playback-state,playlist-read-private,user-top-read,user-read-email,playlist-modify-public,user-library-modify,user-follow-read,user-read-currently-playing,user-read-recently-played"

# temporary code (lasts a few hours?)
code = "AQCZTR5dLkawduzpjA-otpUxL3pw4vR9PSe4R6VdRJvMF1qOcsXGyT6H-zutMFZ781jjw0L__WdBeym22JuNZFE_l3sHs0cz5msYYBWKDuGPO0ZPwYsokdWfbkc2trksN2MGOFZG294ZrmTaqKBvMiyp3gXcW-u0OEZPudcM_J2tcprtoS-wl9SOKw5lr3_Tldd9kRjkSAZsK9i6BrmA3iQn8ZVEtTAJtS_tUZFld-EDtaH8QET3OzxQqST4NZ1uz3tmYsTcy-1S5yRj85WWZZLchFprD7f6-00XXlIHQdUdsNmLUlSsg-ejVMOk6NNjDNQUNXMvYjug4iITvsm67sMhVDufhlnHAAoSeTzKttglC2VRdpA8MuBeUle56uuFYuXA0rOeF0uE0NxxjBSA5Q0IKtXM5EATOc8QX5dznJqhNIEtqOIrVJ7UjTSLqOQEoSjk1hIaJxX2DzTaj6BkzjTk92CWsfsa3O-bEd7sLYVp16wANsSzLatx30tW8nZhneAHJRHucxqP47bD0fa_9PHaO9xAGkgTHGMh4Hj_q1YDTe9ROaW3BaujTgeuZ7_qtmbYLLc4chN3bG8FOkh4ikaNpEJ-zyWjfjD7njh75LNoqkePZ6zbMxtlVG-9b_mGsAvOemxFCMSjBBnH97OtrDEBe8CQ9-3N2jEsOCk7nexgrxBYOMEE2LkeYFeewn9zWR7NMR8xFuWfjUpbLOY"

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