class UsersController < ApplicationController
  before_action :logged_in_user, only:[:edit, :update, :index, :destroy, :show, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,   only: :destroy


  def index
    #if !!params[:asc]
       @users = User.where(activated: true).paginate(page: params[:page])
    #  sort false
    # else
    #   @users = User.order.paginate(page: params[:page]).where(activated: true)
    #  sort true
    #end

  end
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated
  end
  def create
    @user = User.new user_params
    respond_to do |format|
      if @user.save
        @user.send_activation_email
        #UserMailer.account_activation(@user).deliver_now
        flash[:info] = "Please check your email to activate your account."
        format.html { redirect_to root_url }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  def edit
    @user = User.find(params[:id])
    #@user = User.find(current_user)
  end
  def update
    @user = User.find(params[:id])
    messages = []
    if user_params[:password].nil? || user_params[:password].empty?
      # Filling all fields without validation except password
      user_params.each do |key, value|
      if !value.empty? && user_params[:password] == user_params[:password_confirmation] && @user[key] != value
        @user.update_attribute( key,  value)
        messages.push "#{key}"
      end
      end
    else
      # Filling all fields with validation
      return render :edit  unless @user.update(user_params)
      messages.push "All information of profile"
    end
    if messages.length != 0
    redirect_to @user, success_notice:
      messages.join(', ').concat(" was successful updated.")
    else
      redirect_to @user
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  #Действия following и followers
  def following
  @title = "Following"
  @user = User.find(params[:id])
  @users = @user.following.paginate(page: params[:page])
  render 'show_follow'
end
def followers
  @title = "Followers"
  @user = User.find(params[:id])
  @users = @user.followers.paginate(page: params[:page])
  render 'show_follow'
end


  private

  def user_params

    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    unless current_user? @user
      redirect_to root_url, danger_notice: "You have the limit permissions for this operation."
    end
  end
  # Validation available administration permissions.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
