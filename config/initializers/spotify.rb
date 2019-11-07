Rails.application.configure do
  config.spotify_client_id = ENV['SPOTIFY_CLIENT_ID']
  config.spotify_client_secret = ENV['SPOTIFY_CLIENT_SECRET']
end