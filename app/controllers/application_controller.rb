class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper


  private
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      store_location
      redirect_to login_url
    end
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

end
