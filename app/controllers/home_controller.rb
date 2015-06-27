class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    redirect_to statuses_path if user_signed_in?
  end
end
