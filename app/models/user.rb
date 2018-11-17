class User < ApplicationRecord
  DEFAULT_NAME_REGEXP = /\A([a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+)/
  has_secure_password
  after_create :send_welcome_email
  before_create :set_default_name

  validates :name, length: {minimum: 5}, presence: true,
    if: Proc.new { |user| user.name != user.default_name },
    on: :update

  validates :email, presence: true,
    uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, length: {minimum: 8},
    unless: Proc.new { |user| user.password.nil? }

  def self.authenticate(email, password)
    user = User.find_by(email: email)

    if user and user.authenticate(password)
      return user
    else
      sleep((100.0 + rand(500.0)) / 1000.0)
      return false
    end
  end

  def default_name
    self.email[DEFAULT_NAME_REGEXP]
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def reset_password_token_expired?
    self.reset_password_sent_at + 6.hours <= Time.now
  end

  def generate_reset_password_token
    self.reset_password_token = Digest::SHA1.hexdigest("#{self.email}#{Time.now.to_i}")
    self.reset_password_sent_at = Time.now()
    self.save
    return self.reset_password_token
  end

  private
    def set_default_name
      self.name = self.default_name
    end

    def send_welcome_email
      UserMailer.welcome(self).deliver_now
    end
end
