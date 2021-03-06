class Micropost < ApplicationRecord
  belongs_to :user
  # The default_scope method is given by rails 
  # and takes an anonymous method as an argument
  # which sets the default order in which objects
  # are retrieved from the database.
  mount_uploader :picture, PictureUploader
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size


private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end


end
