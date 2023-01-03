class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save { email.downcase }
  before_create :create_activation_digest

  validates :name, presence: true, length: {minimum: 2, maximum: 50}
  VALID_EMAIL = /\A[a-zA-Z0-9.!\\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-\\.]{0,61}|[a-zA-Z0-9])(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)(\\.|[a-zA-Z0-9-])*\z/
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL},
          uniqueness: { case_sensitive: false }
  has_secure_password
  VALID_PASSWORD =  /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_+])[A-Za-z\d\W_+]{7,72}/
  validates :password, length: {minimum: 7}, allow_nil: true #, format: {with:VALID_PASSWORD}
  validates_format_of :password , with:VALID_PASSWORD,
                      :message => "must be have at least one capital char, one little char, digits and special symbols"


  class << self

  # Возвращает дайджест для указанной строки.
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
             BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  def generate_token(column)
    begin
      self[column]= SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  # Возвращает случайный токен.
  def new_token
    SecureRandom.urlsafe_base64
  end
  end
  # Возвращает случайный токен.
  def generate_token(column)
    begin
      self[column]= SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  # Запоминает пользователя в базе данных для использования в постоянных сеансах.
  def  remember
    self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
  end
  # Возвращает true, если указанный токен соответствует дайджесту.
  def   authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  # Забывает пользователя
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Активирует учетную запись.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  # Посылает письмо со ссылкой на страницу активации.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Устанавливает атрибуты для сброса пароля.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end
  # Посылает письмо со ссылкой на форму ввода нового пароля.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end



  # Возвращает true, если время для сброса пароля истекло.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private
  # Преобразует адрес электронной почты в нижний регистр.
  def downcase_email
    self.email = email.downcase
  end
  def create_activation_digest
    # Создать токен и дайджест.
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
