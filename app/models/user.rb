class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z0-9\-.]+\.[a-z]+\z/i.freeze

  has_secure_password
  attr_accessor :remember_token, :activation_token

  validates :name, presence: true
  validates :email, presence: true,
    length: {maximun: Settings.max_length_250, minimum: Settings.min_length_1},
    uniqueness: true, format: {with: VALID_EMAIL_REGEX}
  validates :password, presence: true,
    length: {maximun: Settings.max_length_250, minimum: Settings.min_length_1},
    allow_nil: true

  before_save :downcase_email
  before_create :create_activation_digest

  def self.digest string
    cost =  if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine.cost
            end
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  # Activates an account.
  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    email.downcase!
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
