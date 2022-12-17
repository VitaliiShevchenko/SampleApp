class User < ApplicationRecord
  before_save { email.downcase }
  validates :name, presence: true, length: {minimum: 2, maximum: 50}
  VALID_EMAIL = /\A[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-\.]{0,61}|[a-zA-Z0-9])(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)(\.|[a-zA-Z0-9-])*\z/
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL},
          uniqueness: { case_sensitive: false }
  has_secure_password
  VALID_PASSWORD =  /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_+])[A-Za-z\d\W_+]{7,20}/
  validates :password, length: {minimum: 7}#, format: {with:VALID_PASSWORD}
  validates_format_of :password , with:VALID_PASSWORD,
                      :message => "must be have at least one capital char, one little char, digits and special symbols"
end