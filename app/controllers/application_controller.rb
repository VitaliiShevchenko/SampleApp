class ApplicationController < ActionController::Base
  add_flash_types :success_notice
  add_flash_types :danger_notice
  protect_from_forgery with: :exception
  #skip_before_action :verify_authenticity_token
  include SessionsHelper
end
