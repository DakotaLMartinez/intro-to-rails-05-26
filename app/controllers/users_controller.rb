class UsersController < ApplicationController
  def new 
    @user = User.new
  end 

  def create 
    @user = User.new(user_params)
    binding.pry
    if @user.save 
      session[:user_id] = @user.id
    else
      render :new
    end
  end

  private 

  # strong parameters create a whitelist of attributes that are allowed through into user_params
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
