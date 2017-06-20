class AdminUser < ApplicationRecord
  include EntityAuthentication

  mount_uploader :image, PictureUploader
  validates :email, presence: true, email: true

  has_secure_password
end
