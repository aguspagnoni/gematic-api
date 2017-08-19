class AdminUser < ApplicationRecord
  include EntityAuthentication

  mount_uploader :image, PictureUploader
  validates :email, presence: true, email: true, uniqueness: true
  STATUSES = [:back_office, :supervisor, :superadmin].freeze # defaults to 0 -> :back_office
  enum privilege: STATUSES

  has_secure_password
end
