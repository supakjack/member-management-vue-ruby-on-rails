class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable
  enum role: [:user, :moderator, :admin]   
  after_initialize :set_default_role, :if => :new_record?
  before_validation :generate_auth_token, on: [:create]

  def set_default_role
    self.role ||= :user   
  end
  
  def generate_auth_token(force = false)
    self.auth_token ||= SecureRandom.urlsafe_base64    
    self.auth_token = SecureRandom.urlsafe_base64 if force    
  end

  def jwt(exp = 1.dyas.form_now)
    payload = { exp: exp.to_i, auth_token: self.auth_token }
    JWT.encode payload, Rails.application.credentials.secret_key_base, 'HS256'
  end

  def has_role?(role)
    self.role.to_sym  == role.to_sym 
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
