class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by( email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_url, success_notice: "Email sent with password reset instructions"
    else
      flash.now[:danger_notice] = "Email address not found"
      render :new
    end
  end

  def edit
  end

  def update
    if password_blank?
      flash.now[:danger_notice] = "Password can't be blank"
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      redirect_to @user, success_notice: "Password has been reset."
    else
      render 'edit'
    end
  end




  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Возвращает true, если пароль пустой.
  def password_blank?
    params[:user][:password].blank?
  end

  # Предварительные фильтры
  def get_user
    @user = User.find_by(email: params[:email])
  end

# Подтверждает допустимость пользователя.
def valid_user

  flash[:danger] = "user=#{@user} && user.activated?=#{@user.activated?} && user.authenticated?(:reset, params[:id]=#{params[:id]})=#{@user.authenticated?(:reset, params[:id])} === #{(@user && @user.activated? && @user.authenticated?(:reset, params[:id]))}"
  unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))

 redirect_to root_url
  end
end
  # Проверяет срок действия токена.
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end
