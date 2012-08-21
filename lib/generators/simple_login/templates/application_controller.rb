class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  private
  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

  def authorize
    redirect_to login_url, alert: "Not authorized. Please login." if current_user.nil?
  end
end
