class NewUser < ApplicationRecord
    before_save { self.email = email.downcase }
    validates :name, presence: true, length: {maximum: 50}
    validates :email, presence: true, length: {maximum: 255}, format: {with: URI::MailTo::EMAIL_REGEXP},
              uniqueness: { case_sensitive: false }
    has_secure_password
    VALID_PASSWORD =  /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_+])[A-Za-z\d\W_+]{7,20}/
    validates :password, length: {minimum: 7}, format: {with:VALID_PASSWORD}

end
