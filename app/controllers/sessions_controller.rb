class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate?(params[:user][:password])
      session[:user_id] = @user.id 
      redirect '/posts'
    else
      render :new
    end
  end

  def destroy
    session.clear
  end
  
end
