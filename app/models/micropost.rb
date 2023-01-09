class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  has_rich_text :content
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140}
  validate :picture_size


  private
    # Проверяет размер выгруженного изображения.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
