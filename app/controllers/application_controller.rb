class ApplicationController < ActionController::Base
  add_flash_types :success_notice
  add_flash_types :danger_notice
  protect_from_forgery with: :exception
  #skip_before_action :verify_authenticity_token
  include SessionsHelper

  private

  # Validation right of user.
  def logged_in_user
    unless logged_in?
      store_location
      redirect_to login_url, danger_notice: "Please log in."
    end
  end
end
