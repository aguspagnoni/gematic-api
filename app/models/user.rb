class User < ApplicationRecord
  include EntityAuthentication

  belongs_to :company
  mount_uploader :image, PictureUploader
  validates :email, presence: true, email: true

  has_secure_password
end
