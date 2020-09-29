class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z0-9\-.]+\.[a-z]+\z/i.freeze

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true,
    length: {maximun: Settings.email.max, minimum: Settings.email.min},
    uniqueness: true, format: {with: VALID_EMAIL_REGEX}

  before_save :downcase_email

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

  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  attr_accessor :remember_token

  private

  def downcase_email
    email.downcase!
  end
end
