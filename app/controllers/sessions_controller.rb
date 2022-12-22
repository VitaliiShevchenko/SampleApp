  class SessionsController < ApplicationController
    def index

    end
  def new

  end

  def destroy
    #debugger
    log_out
    flash[:notice] = "You have successfully logged out."
    redirect_to root_url
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      flash[:notice] = "Welcome to our site"
     redirect_to @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render action: :new
    end


  end
end
