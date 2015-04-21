class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def spotify
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.update(spotify_user: RSpotify::User.new(request.env['omniauth.auth']).to_hash)
    sign_in_and_redirect @user
  end
end