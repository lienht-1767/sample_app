class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content_max}
  validate  :picture_size

  scope :desc_created_at, -> {order created_at: :desc}
  scope :feed, ->(user_id) {where user_id: user_id}

  private
  def picture_size
    return unless picture.size > Settings.size.megabytes
    errors.add :picture, I18n.t(".microposts.picture_size.size")
  end
end
