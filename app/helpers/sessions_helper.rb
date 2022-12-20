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
  # Осуществляет выход текущего пользователя.
  def log_out
    #debugger
    session.delete[:user_id]
    @current_user = nil
  end
end
