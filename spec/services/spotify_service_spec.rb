require "rails_helper"

RSpec.describe SpotifyService, :vcr do
  describe ".authenticate" do
    it "returns false if the access code is invalid" do
      code = "invalid-code"
      expect(SpotifyService.authenticate(code)).to eq(false)
    end

    it "if the access code is valid stores access token in db and returns the user" do
      # Temporary code - must be replaced with a new code to re-generate the cassette
      # URL to generate code: https://accounts.spotify.com/authorize?client_id=#{SPOTIFY_CLIENT_ID}&response_type=code&redirect_uri=http%3A%2F%2Flocalhost:3000%2Fcallback&scope=user-follow-modify,user-library-read,playlist-read-collaborative,playlist-modify-private,user-modify-playback-state,streaming,app-remote-control,user-read-private,user-read-birthdate,user-read-playback-state,playlist-read-private,user-top-read,user-read-email,playlist-modify-public,user-library-modify,user-follow-read,user-read-currently-playing,user-read-recently-played
      code = "AQBbYzJwWQ9gNskeH3Stg6dlSN9jqYguA4cK50gJp-GAvHopS3tGIWgqBk3FrHqFmhnq9UFd3yBCPdVwhftnD6z0nY7puM1YJAjQJAyrNHym4mQiCUwLLKOnzBlVwPDeupnm0eiXJTglKX6wU4_Dx930Rv6eld6jazQLHFZDPSa-qGvJ8qTLNxzWMX7zhJrOx-PpL0Fdzn4KW3ridJRwETuvoQWN5GoE7KytE__937uDjVF5F3G0PPUrlBrU0DaAQsMpny65qzstMT3aDiLkt6r9qbd2JhvOqqMu-UO4puA8DVd2s2bGO4pIPZmTjYb57ZrdMT6CRDBDHSRJJ4MUkcXAriZgkSXVA1vqfQV6IBW556njWlfpgbzT-aM5_1KcNj5r11Qu-9XEWKRPm4m1BdrVi6w2Tam5pSvLrfYONOcRy2OMCh4jngs6SWIYO9JrtMnh2iPfem9pbZ9mvDkUzM6bxn_RbzAhfRyFjtdkg_eny2aN0NcNCFnBFFvr3aM3drFB62Az2lFr9eXgONDIKhNIR9Q0rWEc86-jmbtIkyDjqHuqnev8BBTbEX7E2A_paBSw9FayIakRU2PBgevlcMG115JzE7icaFNATGc6RzSeivz-S7k871DQHF6OAhsOewyPXUG8j4mGSLxmiB99jd_0JnRhAaBDFdayHUorkqLQ6QMA58PMzTJeYxN1zzcaCOYS_dpHESZChrIP4I4"

      expect do
        expect(SpotifyService.authenticate(code)).to be_a(User)
      end.to change { User.count }.by(1)
    end
  end

  describe ".get_recent_albums_for" do
    let(:user) { User.new(access_token: "BQBQPOPfqMewO4GN65W8PYV_fB-CLecFbkd_9xNdkm7m1ScR24gU8TMccz2Ld0ePQD1HX-umnvrfk7IYPNF-HrGpeaosC6eQlai9OSF5XFmtzqt9Rb1ni6jhZ7XsAfTTMkHV3xvK4tiYkPtB07nWxGvdo7aRllhYZ8LtDV3Whnwo-3YzvFhXz1fj3JhBvJeOgBURmS0HMT8GvLuaJH1tWnGsXYwfwt24fyHvmA6YTJ0-lCfFQrGNl3_jITDJNhetYkd9nBNl_970iqV7h2ZDdbqFGrcGr5cGqQ") }

    it "returns albums released within the time frame" do
      time_of_spotify_api_request = Time.local(2019, 6, 6, 11, 24, 0)
      
      Timecop.travel(time_of_spotify_api_request) do
        albums = SpotifyService.get_recent_albums_for(user: user, released_cutoff_date: 2.week.ago)

        expect(albums).not_to be_empty
        expect(albums.count).not_to eq(0)
      end
    end
  end
end