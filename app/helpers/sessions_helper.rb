module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  # Поиск текущего Пользователя в сеансе
  def current_user
    current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end
end
def log_out
  session.delete(:current_user)
  @current_user = nil
end

