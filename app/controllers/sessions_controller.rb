  class SessionsController < ApplicationController
    def index

    end
  def new

  end

  def destroy
    #debugger

    log_out if logged_in?
    redirect_to root_url
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user &.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] === "1" ? remember(@user) : forget(@user)
      flash[:notice] = "Welcome to our site"
     redirect_to @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render action: :new
    end


  end
end
