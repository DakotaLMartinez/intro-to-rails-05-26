class ApplicationController < ActionController::Base
  add_flash_types :info, :error, :warning
  private 

  def current_user 
    User.find_by_id(session[:user_id])
  end
end
