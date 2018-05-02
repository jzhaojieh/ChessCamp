class SessionsController < ApplicationController
  include AppHelpers::Cart
  def new
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to home_path, notice: "Logged in!"
      create_cart
    else
      flash.now.alert = "Username and/or password is invalid"
      render "new"
    end
  end
  
  def destroy
    destroy_cart
    session[:user_id] = nil
    redirect_to home_path, notice: "Logged out!"
  end
  #new route and function
  #add registration, remove, and checkout
end
