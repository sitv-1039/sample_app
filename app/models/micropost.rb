class Micropost < ApplicationRecord
  belongs_to :user
  scope :recent_posts, ->{order created_at: :desc}
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.max_length_140}
  validates :image,
            content_type: {in: %w(image/jpeg image/gif image/png),
                           message: "must be a valid image format"},
            size: {less_than: 5.megabytes,
                   message: I18n.t("model.microposts.should_be_less_than_5MB")}

  def display_image
    image.variant resize_to_limit: [Settings.value_500, Settings.value_500]
  end
end
