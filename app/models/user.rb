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
    Bcrypt::Password.create(string, cost: cost)
  end

  private

  def downcase_email
    email.downcase!
  end
end
