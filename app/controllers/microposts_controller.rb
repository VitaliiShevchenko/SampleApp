class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    respond_to do |format|
    if @micropost.save
      flash[:success] = "Micropost created!"
      format.turbo_stream { render turbo_stream: turbo_stream.prepend(@micropost) }
      format.html         { redirect_to root_url }
    else
      flash[:danger] = "Micropost not created!"
      @feed_items = []
      format.html         { render 'static_pages/home' }
    end
    end
  end
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end


  private
def micropost_params
  params.require(:micropost).permit(:content, :picture)
end
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
