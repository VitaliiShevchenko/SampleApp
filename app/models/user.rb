class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { email.downcase }
  validates :name, presence: true, length: {minimum: 2, maximum: 50}
  VALID_EMAIL = /\A[a-zA-Z0-9.!\\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-\\.]{0,61}|[a-zA-Z0-9])(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)(\\.|[a-zA-Z0-9-])*\z/
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL},
          uniqueness: { case_sensitive: false }
  has_secure_password
  VALID_PASSWORD =  /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_+])[A-Za-z\d\W_+]{7,72}/
  validates :password, length: {minimum: 7}, allow_nil: true #, format: {with:VALID_PASSWORD}
  validates_format_of :password , with:VALID_PASSWORD,
                      :message => "must be have at least one capital char, one little char, digits and special symbols"
  before_create { generate_token(:auth_token) }
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
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  # Забывает пользователя
  def forget
    update_attribute(:remember_digest, nil)
  end

end
