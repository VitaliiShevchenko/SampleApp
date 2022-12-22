module SessionsHelper
  def log_in(user)
    session[:current_user_id] = user.id
  end

  # Поиск текущего Пользователя в сеансе` `
  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id])
  end

  def logged_in?
    !current_user.nil?
  end
end
def log_out
  #debugger
  session.delete(:current_user_id)
  @current_user = nil
end

