  class SessionsController < ApplicationController
    def index

    end
  def new

  end

  def destroy
    #debugger
    #Rails.logger "#{current_user}"
    log_out if logged_in?
    redirect_to root_url
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user &.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] === "1" ? remember(@user) : forget(@user)
        flash[:notice] = "Welcome to our site"
        redirect_back_or @user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end

    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new
    end


  end
end
