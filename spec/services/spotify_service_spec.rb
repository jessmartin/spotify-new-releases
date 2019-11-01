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
      code = "some-secret-code"

      expect do
        expect(SpotifyService.authenticate(code)).to be_a(User)
      end.to change { User.count }.by(1)
    end
  end

  describe ".get_recent_albums_for" do
    let(:user) { User.new(access_token: "some-access-token") }

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