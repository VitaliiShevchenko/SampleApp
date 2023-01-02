module SessionsHelper


  def log_in(user)
    session[:current_user_id] = user.id
  end
  # Запоминает пользователя в постоянном сеансе.
  def remember(user)
    user.remember
    cookies.permanent.signed[:current_user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Возвращает пользователя, соответствующего токену в cookie.
  def current_user
    #@current_user ||= User.find_by(id: session[:current_user_id]) if session[:current_user_id]

    if (user_id = session[:current_user_id])
      @current_user ||= User.find_by(id:user_id)
    elsif (user_id = cookies.signed[:current_user_id])
      user = User.find(user_id)
      if user &.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  # Возвращает true, если данный пользователь является текущим.
  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil?

  end
  # Закрывает постоянный сеанс.
  def forget(user)
    user.forget
    cookies.delete(:current_user_id)
    cookies.delete(:remember_token)
  end
  def log_out
    forget(current_user)
    session.delete(:current_user_id)
    @current_user = nil
  end
  # Перенаправить по сохраненному адресу или на страницу по умолчанию.
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default )
    session.delete(:forwarding_url)
  end
  # Запоминает URL.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
  def sort(value)
    @asc = value
  end
end


