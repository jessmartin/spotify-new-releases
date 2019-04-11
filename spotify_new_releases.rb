SPOTIFY_CLIENT_ID = "e3f4e0c2b60443c29893e9356dc48f8e"
SPOTIFY_CLIENT_SECRET = "3c2c297f48d64a64b9a9147ef3e742f6"

# spotify-ruby

require 'spotify'

# Connect to Spotify app
@accounts = Spotify::Accounts.new
@accounts.client_id = "e3f4e0c2b60443c29893e9356dc48f8e"
@accounts.client_secret = "3c2c297f48d64a64b9a9147ef3e742f6"
@accounts.redirect_uri = "http://localhost:9292/callback"

# FIXME: URL generated includes `oauth`
@accounts.authorize_url

## Have to get the code from a callback URL
code = "nada"

# FIXME: wrong number of arguments in the method call from the Accounts object
@session = @accounts.exchange_for_session(code)

@session.crank_it_up

def this_is_a_method
  puts "I'm a method, silly!"
end

##=============================================##

# RSpotify

require 'rspotify'

RSpotify.authenticate("e3f4e0c2b60443c29893e9356dc48f8e", "3c2c297f48d64a64b9a9147ef3e742f6")

# Hit this URL: => "https://accounts.spotify.com/authorize?client_id=e3f4e0c2b60443c29893e9356dc48f8e&redirect_uri=http%3A%2F%2Flocalhost%3A9292%2Fcallback&response_type=code&scope=playlist-read-private+playlist-read-collaborative+playlist-modify-public+playlist-modify-private+ugc-image-upload+user-follow-modify+user-follow-read+user-library-read+user-library-modify+user-read-private+user-read-birthdate+user-read-email+user-top-read+user-read-playback-state+user-modify-playback-state+user-read-currently-playing+user-read-recently-played+streaming+app-remote-control"
# Grab the code and store below
code = "AQA3nBf40FEagp0w0vLCFOH2mfExaiuqhwBBCTwLi9wftW9SX0f6-597HsJMZiot_LwUwRQafEy_qUhnpHjRvb4sS9XRujCwq7_1aLKZh--R-u-HIB9bJX8S01PRZMgME4d1SqvfxLibr3YjKtdf9BOAsBSbirSca-uyyGKY_h9MJ7wzmtZLvj3DcZwCs1S-Pa-TEIQ0iY87gSAlZYyxn18fkYQAHjSa97ueP1VfP7-U04-j3gy7sjnp4qnKrN6nbjz2iNChtIVXe2AkCEk0cZprQQ0hGPwqdq7YPcBAUHt76tYH63DERUtkfg_NwQKF0Sxk3Ffli5G5ZcZdw3Nwi3hCSnT4IPAdqBNfE5S0SZCfjwHiErU4qRGTqd0hn7zXGjV5vz4I4usJuIU1GGdEkzibi2KwqBrHMUYOs9f_fqCEZ8eLPLWJEvKVLv44LjSLDbtPqrTurMuN_hYKESSE1OzQ2p1m5kVmIJvoL53av2_IDZORVcYCGaK4bBHkA2Bxcs8el8Z7hROerbs-mqbGrWoC-dk7q3tQ8oxRlpbgmXDlOuc3cTOvmPi11uHnaaSsJuQjW6Eb4JWoyKj0xbav4pcGKAA4qTHpNWxc6GUT5h2pJKMDTS6IQ8g8rmhsZQqBiHXX5Kd2kFr9nNifkJu1zWCoA1Ph0gcrAUgrC6GAB46FEqXRnvfHWlB3BAjGc_E4S2PnF-oTyjzIJr31CYipcxEqK195oQ-bbJcrQ2uonyQ"

auth_response = HTTParty.post("https://accounts.spotify.com/api/token",
                              headers: { 'Accept' => 'application/json' },
                              body: {
                                'client_id' => SPOTIFY_CLIENT_ID,
                                'client_secret' => SPOTIFY_CLIENT_SECRET,
                                code: code,
                                grant_type: "authorization_code",
                                redirect_uri: "http://localhost:9292/callback"
                              })

# ap auth_response.parsed_response
#{
#     "access_token" => "BQD6a8CKJC8YTa...O8J4E3IXeokL98298aI",
#       "token_type" => "Bearer",
#       "expires_in" => 3600,
#    "refresh_token" => "AQA5-xU0OzWc6R...bqWfKAsw6IO4",
#            "scope" => "user-read-email user-read-private"
#}
headers = {
  'Authorization' => "Bearer #{auth_response["access_token"]}"
}

info_response = HTTParty.get 'https://api.spotify.com/v1/me',
  headers: headers

options = {
  'credentials' => auth_response.parsed_response,
  'info' => info_response.parsed_response
}
user = RSpotify::User.new options
