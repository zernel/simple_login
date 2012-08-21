class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :password, :password_confirmation

  validates :email, presence: true, uniqueness: true, format: { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/ }
  validates :password, presence: true, length: 6..20, on: :create

  before_create { generate_token(:auth_token) }
  after_create { send_account_confirmation }

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def send_account_confirmation
    UserMailer.account_confirmation(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
