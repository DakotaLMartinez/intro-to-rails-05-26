class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id 
      redirect '/posts'
    else
      @user ||= User.new
      @error = "Invalid email password combination"
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to login_path
  end
  
end
