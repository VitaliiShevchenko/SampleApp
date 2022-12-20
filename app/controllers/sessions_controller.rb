  class SessionsController < ApplicationController
    def index

    end
  def new

  end

  def destroy
    log_out
    redirect_to root_url
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
     redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new, status: 422
    end


  end
end
