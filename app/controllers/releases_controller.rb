class ReleasesController < ApplicationController
  def index
    remember_token = cookies[:remember_token]
    user = User.find_by(remember_token: remember_token)

    @albums = SpotifyService.get_recent_albums_for(user: user, released_after: 3.months.ago)
  end
end