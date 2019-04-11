require 'httparty'

class ReleasesController < ApplicationController
  def index
    access_token = ""

    followed_artists_response = HTTParty.get("https://api.spotify.com/v1/me/following", 
      query: { type: 'artist' },
      headers: {"Authorization" => "Bearer #{access_token}"})

    followed_artists = followed_artists_response["artists"]["items"]

    all_albums = followed_artists.collect do |artist|
      albums_response = HTTParty.get("https://api.spotify.com/v1/artists/#{artist["id"]}/albums", 
                                      headers: {"Authorization" => "Bearer #{access_token}"})
      albums_response["items"]
    end.flatten

    @albums = all_albums.select do |album|
      next if album["release_date_precision"] != "day"
      Date.today - 365 < Date.parse(album["release_date"])
    end
  end

end