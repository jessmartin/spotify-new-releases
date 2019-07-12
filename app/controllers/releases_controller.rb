class ReleasesController < ApplicationController
  def index
    remember_token = cookies[:remember_token]
    user = User.find_by(remember_token: remember_token)

    albums = SpotifyService.get_recent_albums_for(user: user, released_after: 18.months.ago)

    @albums = albums.select { |a| a["release_date_precision"] == "day" }
                    .sort { |a, b| b["release_date"] <=> a["release_date"] }
  end
end